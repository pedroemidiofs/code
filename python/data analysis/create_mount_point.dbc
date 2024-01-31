app_id = dbutils.secrets.get(scope = 'keyvault', key = 'Appid')
app_secret = dbutils.secrets.get(scope = 'keyvault', key = 'AppSecret')

configs = {
    "fs.azure.account.auth.type": "OAuth",
    "fs.azure.account.oauth.provider.type": "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider",
    "fs.azure.account.oauth2.client.id": app_id,
    "fs.azure.account.oauth2.client.secret": app_secret,
    "fs.azure.account.oauth2.client.endpoint": "https://login.microsoftonline.com/abcdergh123456789/token"
} 

dbutils.fs.mount(
  source = "abfss://nomedodatalake.dfs.core.windows.net/",
  mount_point = "/mnt/teste",
  extra_configs = configs) 
