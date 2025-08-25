from pyspark.sql.functions import from_json, col
from pyspark.sql.types import StructType, StringType, TimestampType

# Schema do JSON recebido
schema = StructType() \
    .add("id", StringType()) \
    .add("value", StringType()) \
    .add("event_time", TimestampType())

# Configurações do Event Hub
event_hub_conf = {
    'eventhubs.connectionString': dbutils.secrets.get(scope="kv-scope", key="eventhub-connection")
}

# Leitura em tempo real
df_stream = (
    spark.readStream
         .format("eventhubs")
         .options(**event_hub_conf)
         .load()
)

# Decodificando a mensagem JSON
df_json = df_stream \
    .selectExpr("cast(body as string) as json_str") \
    .select(from_json("json_str", schema).alias("data")) \
    .select("data.*")

# Escrita em Delta Lake no Data Lake Gen2
query = (
    df_json.writeStream
           .format("delta")
           .outputMode("append")
           .option("checkpointLocation", "/mnt/raw/checkpoints/eventhub/")
           .start("/mnt/bronze/streaming_data/")
)

query.awaitTermination()
