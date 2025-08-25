####################################################################################
#Provisiona um Data Lake Gen2 no Azure pronto para ingestão e análise de dados.
####################################################################################
resource "azurerm_storage_account" "datalake" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = true

  blob_properties {
    delete_retention_policy {
      days = 30
    }
  }
  tags = var.tags
}


resource "azurerm_storage_data_lake_gen2_filesystem" "datalake" {
  name                  = "datalake"
  storage_account_id    = azurerm_storage_account.datalake.id
}


# Cria diretórios usando a API Data Lake Gen2
resource "azurerm_storage_data_lake_gen2_path" "bronze_dir" {
  path               = "bronze"
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.datalake.name
  storage_account_id = azurerm_storage_account.datalake.id
  resource           = "directory"
  
  ace {
    type        = "group"
    id          = var.bronze_group_object_id
    permissions = "rw-"  # Leitura (r), Escrita (w)
    scope       = "access"
  }
}

resource "azurerm_storage_data_lake_gen2_path" "silver_dir" {
  path               = "silver"
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.datalake.name
  storage_account_id = azurerm_storage_account.datalake.id
  resource           = "directory"
  
  ace {
    type        = "group"
    id          = var.silver_group_object_id
    permissions = "rwx"  
    scope       = "access"
  }
}


resource "azurerm_storage_data_lake_gen2_path" "gold_dir" {
  path               = "gold"
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.datalake.name
  storage_account_id = azurerm_storage_account.datalake.id
  resource           = "directory"
  
  ace {
    type        = "group"
    id          = var.gold_group_object_id
    permissions = "r--"   # somente leituras
    scope       = "access"
  }
}



# Exemplo de Lifecycle Policy ajustar depois
resource "azurerm_storage_management_policy" "lifecycle" {
  storage_account_id = azurerm_storage_account.datalake.id

  rule {
    name    = "delete-old-files"
    enabled = true
    filters {
      blob_types = ["blockBlob"]
      prefix_match = ["bronze/", "silver/"]
    }
    actions {
      base_blob {
        delete_after_days_since_modification_greater_than = 180
      }
    }
  }
}


resource "azurerm_storage_blob" "source_file" {
  name                   = "transacoes_fraude.csv"
  storage_account_name   = var.storage_account_name
  storage_container_name = "datalake"
  type                   = "Block"
  source                 = "C:/Projetos/batch-streaming/dados_teste/azure_data_factory/transacoes_fraude.csv"
}


