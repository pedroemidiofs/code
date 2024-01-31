pip install msal

from pyspark.sql.functions import col, count, array, concat, lit, explode, udf, concat

import msal
import requests

powerappsuser_response = (spark.read
  .format("csv")
  .option("header",True)
  .load("/mnt/teste/example")
)

powerappsuser_response = powerappsuser_response.select(
    col('admin_powerplatformuserid').alias('group'),
    concat(lit('https://graph.microsoft.com/v1.0/groups/'),col('group'),lit('/transitiveMembers')).alias('url')
)



app_id = dbutils.secrets.get(scope = 'keyvault', key = 'appId')
app_secret = dbutils.secrets.get(scope = 'keyvault', key = 'appSecret')

config = {
  'client_id': app_id,
  'client_secret': app_secret,
  'authority': 'https://login.microsoftonline.com/abcdef12345678',
  'scope': ['https://graph.microsoft.com/.default']
}


def make_graph_call(url):

    client = msal.ConfidentialClientApplication(
        config['client_id'], authority=config['authority'], client_credential=config['client_secret']
    )

    token_result = client.acquire_token_silent(config['scope'], account=None)

    if not token_result:
        token_result = client.acquire_token_for_client(scopes=config['scope'])

    if 'access_token' in token_result:
        headers = {'Authorization': 'Bearer ' + token_result['access_token']}
        graph_results = []

        while url:
            try:
                graph_result = requests.get(url=url, headers=headers).json()
                graph_results.extend([item['id'] for item in graph_result.get('value', [])])
                url = graph_result.get('@odata.nextLink')
            except Exception as e:
                print(f"Error: {e}")
                break
    else:
        print(token_result.get('error'))
        print(token_result.get('error_description'))
        print(token_result.get('correlation'))

    return graph_results


make_graph_call_udf = udf(make_graph_call, ArrayType(StringType()))


powerappsuser_group_expanded = powerappsuser_group.withColumn('result', make_graph_call_udf(powerappsuser_group.url))

powerappsuser_group_expanded = powerappsuser_group_expanded.select(
    'group',
    explode('result').alias('id'),
    lit('powerplatformuser').alias('type')
)


powerappsuser_group_expanded.write.mode('overwrite').parquet('/mnt/teste/result')


