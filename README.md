# Sistema de Streaming de Dados com Azure Event Hub

## Objetivo do Projeto
Sistema de streaming de dados usando Azure Event Hub, consistindo em:
- Um producer que envia eventos simulados para um Event Hub
- Projeto containerizado rodando em um cluster Kubernetes (AKS)

## Arquitetura
- **Producer**: Aplicação Python que gera e envia eventos
- **Azure Event Hub**: Serviço de mensageria que recebe os eventos
- **Azure Kubernetes Service (AKS)**: Cluster onde o producer está rodando
- **Azure Container Registry (ACR)**: Registro de containers onde a imagem está armazenada

## Componentes Principais

### a) Producer (producer/main.py)
- Gera eventos simulados a cada ~3 segundos
- Cada evento contém:
  - timestamp
  - mensagem: "evento simulado"
- Usa a biblioteca azure-eventhub para enviar os eventos
- Inclui logs detalhados para debug

### b) Containerização (producer/Dockerfile)
- Baseado em Python 3.10-slim
- Configurado para não bufferizar logs (PYTHONUNBUFFERED=1)
- Instala dependências do requirements.txt
- Executa o script main.py

### c) Kubernetes
- **Secret (eventhub-connection)**: Armazena a connection string do Event Hub
- **Deployment**: Gerencia o pod do producer
- **Pod**: Executa o container com o producer

## Configuração e Variáveis de Ambiente
- `EVENT_HUB_CONN_STR`: Connection string do Event Hub (armazenada em secret)
- `EVENT_HUB_NAME`: Nome do Event Hub (eh-streaming-data-dev)

## Comandos Principais
```bash
docker build -t acrbatchstreamingdev.azurecr.io/eventhub-producer:latest ./producer
docker push acrbatchstreamingdev.azurecr.io/eventhub-producer:latest
kubectl apply -f producer/deployment.yaml
kubectl logs <pod-name>
kubectl delete deployment eventhub-producer
```

## Segurança
- Connection string armazenada como Kubernetes Secret
- AKS configurado para acessar o ACR
- Autenticação entre AKS e Event Hub via connection string

## Monitoramento
- Logs detalhados no pod
- Status do pod via `kubectl get pods`
- Detalhes do pod via `kubectl describe pod`

## Escalabilidade
- O deployment pode ser escalado horizontalmente
- O Event Hub pode lidar com múltiplos producers
- A arquitetura permite adicionar mais consumidores

## Próximos Passos Possíveis
1. Adicionar consumidores para processar os eventos
2. Implementar métricas e monitoramento
3. Adicionar mais tipos de eventos
4. Configurar retry policies e tratamento de erros
5. Implementar testes automatizados

## Casos de Uso
Este projeto pode ser usado como base para:
- Processamento de dados em tempo real
- Análise de eventos
- Integração entre sistemas
- Coleta de métricas e logs