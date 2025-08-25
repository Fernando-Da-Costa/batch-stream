FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY main.py .

# Forçar saída não bufferizada dos logs
ENV PYTHONUNBUFFERED=1

CMD ["python", "-u", "main.py"]

