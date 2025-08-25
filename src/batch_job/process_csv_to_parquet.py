from pyspark.sql.types import StructType, StringType, IntegerType

# Define schema opcionalmente
schema = StructType() \
    .add("id", StringType()) \
    .add("value", StringType()) \
    .add("category", StringType()) \
    .add("quantity", IntegerType())

# Lê arquivo CSV do ADLS
df = (
    spark.read
         .option("header", "true")
         .schema(schema)
         .csv("/mnt/raw/batch/input/")
)

# Realiza transformação simples (ex: filtro)
df_filtered = df.filter("quantity > 0")

# Escreve como Delta
df_filtered.write.mode("overwrite").format("delta").save("/mnt/silver/batch_output/")
