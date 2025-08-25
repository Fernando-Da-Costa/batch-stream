resource "azurerm_storage_data_lake_gen2_path" "bronze_events" {
  filesystem_name       = var.filesystem_name
  path                  = "bronze/events"
  storage_account_id    = var.storage_account_id
  resource              = "directory"
  group = "$superuser"
  owner = "$superuser"
}
