# 1 ADF
# 2 Linked Service para o Data Lake usando Managed Identity (mais seguro que chave)
# 3 Linked Service para o arquivo local (via blob staging ou upload prévio)
# 4 Dataset de origem e dataset de destino
# 5 Pipeline de cópia simples
# 6 Trigger manual (para você rodar quando quiser)

# 1. Data Factory
resource "azurerm_data_factory" "adf" {
  name                = "adf-datalake-dev-fernando"
  location            = var.location
  resource_group_name = var.resource_group_name

  identity {
    type = "SystemAssigned"
  }
  
}

# 2. Linked Service - Data Lake (usando Managed Identity)
resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "ls_datalake" {
  name            = "ls_datalake"
  data_factory_id = azurerm_data_factory.adf.id
  url             = "https://${var.storage_account_name}.dfs.core.windows.net"

  use_managed_identity = true
}



# Linked Service para Databricks, necessário para rodar notebooks via ADF
resource "azapi_resource" "ls_databricks" {
  type      = "Microsoft.DataFactory/factories/linkedservices@2018-06-01"
  parent_id = azurerm_data_factory.adf.id
  name      = "ls_databricks"

  body = {
    properties = {
      type           = "AzureDatabricks"
      typeProperties = {
        domain            = var.databricks_workspace_url
        accessToken = {
          type  = "SecureString"       
          value = var.databricks_token
        }
        existingClusterId = var.databricks_cluster_id
      }
    }
  }
}



# 3. Linked Service - Arquivo local via Blob Storage
# (Pré-requisito: subir seu arquivo para um blob temporário antes)
resource "azurerm_data_factory_linked_service_azure_blob_storage" "ls_blob" {
  name              = "ls_blobsource"
  data_factory_id   = azurerm_data_factory.adf.id
  sas_uri           = "https://stdatalakebatchdev001.blob.core.windows.net/?sv=2024-11-04&ss=bfqt&srt=sco&sp=rwdlacupyx&se=2025-08-30T00:46:38Z&st=2025-08-25T16:31:38Z&spr=https&sig=Tr7DMbuvBMvy5AK0FSXUL7jUVOu6s6NuVOpIAORLk2I%3D"
}


# 4. Dataset de origem (arquivo local pré-subido para blob). Cria um dataset no ADF via template ARM, apontando para arquivo no Blob Storage e configurando destino no Data Lake.
resource "azapi_resource" "adf_datasets" {
  type      = "Microsoft.Resources/deployments@2021-04-01"
  name      = "deploy-adf-datasets"
  parent_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}"

  body = {
    properties = {
      mode     = "Incremental"
      template = local.blob_dataset_template
      parameters = {
        dataFactoryName = { value = azurerm_data_factory.adf.name }
        sourceContainer = { value = var.source_blob_container }
        sourceFileName  = { value = var.source_file_name }
        destinationFolder = { value = "datalake" }

      }
    }
  }
}


# 5. Cria um dataset de destino no Data Lake (camada bronze), referenciando o Linked Service do Data Lake e definindo parâmetros de pasta e arquivo para pipelines de cópia de dados.
resource "azapi_resource" "ds_bronze" {
  type      = "Microsoft.DataFactory/factories/datasets@2018-06-01"
  parent_id = azurerm_data_factory.adf.id
  name      = "ds_bronze"

  body = {
    properties = {
      linkedServiceName = {
        referenceName = azurerm_data_factory_linked_service_data_lake_storage_gen2.ls_datalake.name
        type          = "LinkedServiceReference"
      }
      parameters = {
        folderPath = { type = "String" }
        fileName   = { type = "String" }
      }
      type = "AzureDataLakeStoreFile"
      typeProperties = {
        folderPath = "@{dataset().folderPath}"
        fileName   = "@{dataset().fileName}"
        format     = { type = "TextFormat" }
      }
    }
  }
}
resource "azapi_resource" "ds_gold" {
  type      = "Microsoft.DataFactory/factories/datasets@2018-06-01"
  parent_id = azurerm_data_factory.adf.id
  name      = "ds_gold"

  body = {
    properties = {
      linkedServiceName = {
        referenceName = azurerm_data_factory_linked_service_data_lake_storage_gen2.ls_datalake.name
        type          = "LinkedServiceReference"
      }
      parameters = {
        folderPath = { type = "String" }
        fileName   = { type = "String" }
      }
      type = "AzureDataLakeStoreFile"
      typeProperties = {
        folderPath = "@{dataset().folderPath}"
        fileName   = "@{dataset().fileName}"
        format     = { type = "TextFormat" }
      }
    }
  }
}
resource "azapi_resource" "ds_silver" {
  type      = "Microsoft.DataFactory/factories/datasets@2018-06-01"
  parent_id = azurerm_data_factory.adf.id
  name      = "ds_silver"

  body = {
    properties = {
      linkedServiceName = {
        referenceName = azurerm_data_factory_linked_service_data_lake_storage_gen2.ls_datalake.name
        type          = "LinkedServiceReference"
      }
      parameters = {
        folderPath = { type = "String" }
        fileName   = { type = "String" }
      }
      type = "AzureDataLakeStoreFile"
      typeProperties = {
        folderPath = "@{dataset().folderPath}"
        fileName   = "@{dataset().fileName}"
        format     = { type = "TextFormat" }
      }
    }
  }
}



#6. Cria um pipeline no Data Factory que copia dados do dataset de origem (ds_sourcefile) para o dataset de destino (ds_bronze).
resource "azurerm_data_factory_pipeline" "copy_to_bronze" {
  name            = "pipeline_copy_to_bronze"
  data_factory_id = azurerm_data_factory.adf.id

  parameters = {
    fileName   = "transacoes_fraude.csv"   
    folderPath = "bronze"                   
  }
  activities_json = <<JSON
[
  {
    "name": "CopyFromBlobToBronze",
    "type": "Copy",
    "dependsOn": [],
    "policy": {
      "timeout": "7.00:00:00",
      "retry": 0,
      "retryIntervalInSeconds": 30,
      "secureOutput": false,
      "secureInput": false
    },
    "typeProperties": {
      "source": {
        "type": "BlobSource",
        "recursive": false
      },
      "sink": {
        "type": "BlobSink"
      }
    },
    "inputs": [
      {
        "referenceName": "blobDataset",
        "type": "DatasetReference"
      }
    ],
    "outputs": [
        {
          "referenceName": "ds_bronze",
          "type": "DatasetReference",
          "parameters": {
            "fileName": "@pipeline().parameters.fileName",
            "folderPath": "datalake/bronze"
          }
        }
     ]
  }
]
JSON
}



#7. Cria um pipeline no Data Factory que orquestra a execução do pipeline de cópia de dados (pipeline_copy_to_bronze) 
# e o notebook Databricks (Bronze_Access_DataLake) para transformar os dados na camada bronze para a camada silver e gold.
resource "azurerm_data_factory_pipeline" "pipeline_orchestrator" {
  name            = "pipeline_orchestrator"
  data_factory_id = azurerm_data_factory.adf.id

  depends_on = [
    azurerm_data_factory_pipeline.copy_to_bronze,
    azapi_resource.ls_databricks
  ]

  activities_json = <<JSON
[
  {
    "name": "RunCopyToBronze",
    "type": "ExecutePipeline",
    "dependsOn": [],
    "typeProperties": {
      "pipeline": {
        "referenceName": "pipeline_copy_to_bronze",
        "type": "PipelineReference"
      }
    }
  },
  {
    "name": "RunDatabricksNotebook",
    "type": "DatabricksNotebook",
    "dependsOn": [
      {
        "activity": "RunCopyToBronze",
        "dependencyConditions": ["Succeeded"]
      }
    ],
    "linkedServiceName": {
      "referenceName": "ls_databricks",
      "type": "LinkedServiceReference"
    },
    "typeProperties": {
      "notebookPath": "/Workspace/Users/fernando.dataclub@outlook.com/Bronze_Access_DataLake",
      "baseParameters": {
        "bronze_path": "abfss://bronze@stdatalakebatchdev001.dfs.core.windows.net/data/",
        "silver_path": "abfss://silver@stdatalakebatchdev001.dfs.core.windows.net/processed/",
        "gold_path": "abfss://gold@stdatalakebatchdev001.dfs.core.windows.net/final/"
      }
    }
  },
  {
    "name": "RunSilverTransformacaoNotebook",
    "type": "DatabricksNotebook",
    "dependsOn": [
      {
        "activity": "RunDatabricksNotebook",
        "dependencyConditions": ["Succeeded"]
      }
    ],
    "linkedServiceName": {
      "referenceName": "ls_databricks",
      "type": "LinkedServiceReference"
    },
    "typeProperties": {
      "notebookPath": "/Workspace/Users/fernando.dataclub@outlook.com/Silver_Transformacao",
      "baseParameters": {
        "bronze_path": "abfss://bronze@stdatalakebatchdev001.dfs.core.windows.net/data/",
        "silver_path": "abfss://silver@stdatalakebatchdev001.dfs.core.windows.net/processed/",
        "gold_path": "abfss://gold@stdatalakebatchdev001.dfs.core.windows.net/final/"
      }
    }
  },
  {
    "name": "RunGoldTransformacaoNotebook",
    "type": "DatabricksNotebook",
    "dependsOn": [
      {
        "activity": "RunSilverTransformacaoNotebook",
        "dependencyConditions": ["Succeeded"]
      }
    ],
    "linkedServiceName": {
      "referenceName": "ls_databricks",
      "type": "LinkedServiceReference"
    },
    "typeProperties": {
      "notebookPath": "/Workspace/Users/fernando.dataclub@outlook.com/Gold_Agregacao",
      "baseParameters": {
        "bronze_path": "abfss://bronze@stdatalakebatchdev001.dfs.core.windows.net/data/",
        "silver_path": "abfss://silver@stdatalakebatchdev001.dfs.core.windows.net/processed/",
        "gold_path": "abfss://gold@stdatalakebatchdev001.dfs.core.windows.net/final/"
      }
    }
  }
]
JSON
}




# Dispara o pipeline automaticamente após apply
# resource "azapi_resource_action" "run_pipeline" {
#   type        = "Microsoft.DataFactory/factories/pipelines@2018-06-01"
#   resource_id = azurerm_data_factory_pipeline.copy_to_bronze.id
#   action      = "createRun"

#   body = {
#     parameters = {
#       fileName   = "transacoes_fraude.csv"
#       folderPath = "datalake"
#     }
#   }
# }
