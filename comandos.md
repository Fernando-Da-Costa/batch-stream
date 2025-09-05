# Cria o resource group
az group create \
  --name rg-infra-batch-streaming \
  --location eastus

# Verificcar conta
az account set --subscription "1febf2d4-abff-4d1d-a6ef-6809b4078b8f"
 
# Cria o storage account
az storage account create \
  --name tfstatebatchstreaming1 \
  --resource-group rg-infra-batch-streaming \
  --location eastus \
  --sku Standard_LRS \
  --kind StorageV2


# Cria o container tfstate
az storage container create \
  --name tfstate \
  --account-name tfstatebatchstreaming1



#Lista todos os datasets existentes no Data Factory adf-datalake-dev-fernando dentro do resource group especificado.
az datafactory dataset list \
  --factory-name adf-datalake-dev-fernando \
  --resource-group rg-databricks-batchstreaming-dev





1 - No databricks ao criar um cluster, tipo works tem que ser (Standard_D2ds_v6) para testar  Min. 1 Máx.2 Atual 1
2 - Dentro do databricks ir em configurações/programador e criar um token exemplo PET_INICIO. (databricks_token) No arquivo variables.tf, adicionar a variável databricks_token.
3 - lá nas libs do databricks criar:
          com.microsoft.azure:azure-eventhubs-spark_2.12:2.3.22
          com.microsoft.azure:azure-storage:8.6.6
          org.apache.hadoop:hadoop-azure:3.3.4 
          com.azure:azure-identity:1.8.0





