from pyspark.sql.functions import col, regexp_replace, substring, to_timestamp, when, substring
from pyspark.sql.window import Window

usage_response = spark.read.json("/mnt/teste")

admin_app_response = (spark.read
  .format("csv")
  .option("header",True)
  .load("/mnt/teste")
)

df_usage = usage_response.select(
    'appId',
    'objectId',
    to_timestamp('timeAccessed').alias('timeAccessed')
)

df_usage.write.mode("overwrite").saveAsTable("df_usage_table")

df_usage = spark.sql("""
select 
appId,
objectId,
timeAccessed,
LAG(timeAccessed) OVER(PARTITION BY appid, objectid ORDER BY timeAccessed ASC) as lag,
timeAccessed - LAG(timeAccessed) OVER(PARTITION BY appid, objectid ORDER BY timeAccessed ASC) as diferenca,
DATEDIFF(month,(LAG(timeAccessed) OVER(PARTITION BY appid, objectid ORDER BY timeAccessed ASC)),timeAccessed) as diff
from df_usage_table
""")

df_usage = df_usage.withColumn(
    'seasonal',
    when(col('diff') >= 3,1).otherwise(0)
).withColumn(
    'month',
    substring('timeAccessed',0,7)
)

df_usage = df_usage.select(
    'appId',
    'month',
    'seasonal',
    'objectId'
)

df_usage = df_usage.distinct()

df_usage = df_usage.groupBy('month','appId','seasonal').count()

df_app = admin_app_response.select(
    'admin_displayname',
    'admin_appenvironmentdisplayname',
    'admin_appid'
)

df_usage = df_usage.join(
    df_app,
    df_usage.appId == df_app.admin_appid,
    'left'
)


df_usage.coalesce(1).write.mode('overwrite').csv('/mnt/teste/result' , header=True)
