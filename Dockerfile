# Usar uma imagem base com Python + Azure SDK
FROM python:3.10-slim

# Instala dependências
RUN pip install --upgrade pip && \
    pip install pandas azure-storage-blob azure-identity

# Copia o script para o container
COPY batch_job/process_csv_to_parquet.py /app/process.py

# Define diretório de trabalho
WORKDIR /app

# Comando padrão para rodar o job
ENTRYPOINT ["python", "process.py"]
