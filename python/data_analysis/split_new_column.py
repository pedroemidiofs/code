from pyspark.sql.functions import explode_outer, col, split, regexp_replace, substring, when

requests_response = spark.read.option("multiline","true").option("header", "true").option("inferSchema", "true").json("/mnt/teste")

df_requests = requests_response.select(explode_outer("value").alias('value'))
df_requests = df_requests.select(col("value.*"))

df_requests = df_requests.select(
    'c4e_requestid',
    'c4e_statustimestamp'
)

df_requestOpen = df_requestOpen.withColumn(
    'opened_at', split(df_requestOpen['c4e_statustimestamp'], ';').getItem(0)
)
df_requestOpen = df_requestOpen.withColumn(
    'opened_at',regexp_replace("opened_at", "'Open'", "")
)
df_requestClosedApproved = df_requestClosedApproved.withColumn(
    'closed_approved_at', split(df_requestClosedApproved['c4e_statustimestamp'], "Closed - Approved'").getItem(1)
)
df_requestClosedApproved = df_requestClosedApproved.withColumn(
    'closed_approved_at', split(df_requestClosedApproved['closed_approved_at'], ";'").getItem(0)
)
df_requestClosedApproved = df_requestClosedApproved.withColumn(
    'closed_approved_at',regexp_replace("closed_approved_at", ';','')
)
df_requestClosed = df_requestClosed.withColumn(
    'closed_at', split(df_requestClosed['c4e_statustimestamp'], "Closed'").getItem(1)
)
df_requestClosed = df_requestClosed.withColumn(
    'closed_at', split(df_requestClosed['closed_at'], ";'").getItem(0)
)
df_requestClosed = df_requestClosed.withColumn(
    'closed_at',regexp_replace("closed_at", ';','')
)

df_requestClosed.write.mode('overwrite').csv('/mnt/teste/result' , header=True)
