#####################################################################################
# This script reads data from Azure Event Hub and writes it to Delta Lake format (Executar no Databricks)
#####################################################################################
# Configuração para usar Managed Identity no Databricks para autenticação no ADLS Gen2


from pyspark.sql.functions import from_json, col
from pyspark.sql.types import StructType, StringType, DoubleType
import json

#connectionString = dbutils.secrets.get(scope="eh_scope", key="eventhubs-conn-string")
connectionString = dbutils.secrets.get(scope="eventhub-secrets", key="eventhubs-conn-string")

ehConf = {
  'eventhubs.connectionString': connectionString
}

# Define schema
schema = StructType().add("sensor", StringType()).add("value", DoubleType())

# Read Stream
df = (
  spark.readStream
  .format("eventhubs")
  .options(**ehConf)
  .load()
)

# Decode e parse
df_parsed = df \
  .withColumn("body", col("body").cast("string")) \
  .withColumn("json", from_json(col("body"), schema)) \
  .select("json.*")

# Write para Delta
query = df_parsed.writeStream \
  .format("delta") \
  .outputMode("append") \
  .option("checkpointLocation", "abfss://datalake@stdatalakebatchdev.dfs.core.windows.net/checkpoints") \
  .start("abfss://datalake@stdatalakebatchdev.dfs.core.windows.net/bronze/events")

