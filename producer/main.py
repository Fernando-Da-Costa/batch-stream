import os
import time
from azure.eventhub import EventHubProducerClient, EventData

print("[DEBUG] Iniciando script...")

CONNECTION_STR = os.environ["EVENT_HUB_CONN_STR"]
EVENT_HUB_NAME = os.environ.get("EVENT_HUB_NAME", "meu-eventhub")

print(f"[DEBUG] Connection string: {CONNECTION_STR[:20]}...")
print(f"[DEBUG] Event Hub Name: {EVENT_HUB_NAME}")

try:
    print("[DEBUG] Criando producer client...")
    producer = EventHubProducerClient.from_connection_string(
        conn_str=CONNECTION_STR,
        eventhub_name=EVENT_HUB_NAME
    )
    print(f"[INIT] Producer iniciado para Event Hub: {EVENT_HUB_NAME}")

    while True:
        data = {
            "timestamp": time.time(),
            "mensagem": "evento simulado"
        }

        print("[DEBUG] Preparando evento...")
        event = EventData(str(data))
        print("[DEBUG] Enviando evento...")
        producer.send_batch([event])
        print(f"[ENVIADO] {data}")
        time.sleep(3)
except Exception as e:
    print(f"[ERROR] Erro ocorreu: {str(e)}")
    raise
except KeyboardInterrupt:
    print("Encerrando producer...")
finally:
    print("[DEBUG] Fechando producer...")
    producer.close()
