from pyspark.sql.functions import col, explode_outer, regexp_replace


df_service_response = spark.read.json("/mnt/teste")

df_service = df_service_response.select(explode_outer("value").alias('value'))

df_service = df_service.select(col("value.*"))


for column in df_service.columns:
    df_service = df_service.withColumnRenamed(column, column.replace("@OData.Community", "name"))
  

df_service = df_service.filter(df_service.admin_type == 'User')


df_service.coalesce(1).write.mode('overwrite').json('/mnt/teste/file_json')
