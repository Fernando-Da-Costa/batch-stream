 -- External Data Source
IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'DataLakeGold')
CREATE EXTERNAL DATA SOURCE DataLakeGold
WITH (
    LOCATION = 'abfss://gold@stdatalakebatchdev001.dfs.core.windows.net/'
);

-- External File Format
IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'ParquetFormat')
CREATE EXTERNAL FILE FORMAT ParquetFormat
WITH ( FORMAT_TYPE = PARQUET );

-- External Table
IF NOT EXISTS (SELECT * FROM sys.external_tables WHERE name = 'TransacoesPorDia')
CREATE EXTERNAL TABLE TransacoesPorDia (
    id INT,
    nome NVARCHAR(100),
    data_transacao DATE,
    valor DECIMAL(18,2)
)
WITH (
    LOCATION = 'data/transacoes_por_dia/',
    DATA_SOURCE = DataLakeGold,
    FILE_FORMAT = ParquetFormat
);
                      
