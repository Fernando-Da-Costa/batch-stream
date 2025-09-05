output "storage_account_id" {
  value = azurerm_storage_account.datalake.id
}

output "storage_account_name" {
  value = azurerm_storage_account.datalake.name
}

output "datalake_filesystem_id" {
  value = azurerm_storage_data_lake_gen2_filesystem.datalake.id
} 


output "adls_filesystem_id" {
  value = azurerm_storage_data_lake_gen2_filesystem.datalake.id
}

output "primary_access_key" {
  value = azurerm_storage_account.datalake.primary_access_key
}

output "primary_connection_string" {
  value = azurerm_storage_account.datalake.primary_connection_string
}