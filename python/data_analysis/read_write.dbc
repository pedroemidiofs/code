from pyspark.sql.types import StructType,StructField, StringType

usage_response = spark.read.json("/mnt/powerplatform/powerautomate/usage")

schema = StructType([
    StructField('id', StringType(),True),
    StructField('group', StringType(),True)
])

flow_response = (spark.read
  .format("csv")
  .option("header",True)
  .schema(schema)
  .load("/mnt/teste/flow_usage")
)

df_usage = flow_response.join(
  usage_response,
  ['resourceId'],
  "left"
)

df_usage.write.mode('overwrite').parquet('/mnt/teste/parquet')
