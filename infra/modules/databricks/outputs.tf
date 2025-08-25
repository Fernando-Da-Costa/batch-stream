
output "workspace_id" {
  value = azurerm_databricks_workspace.databricks.id
}

output "workspace_url" {
  value = azurerm_databricks_workspace.databricks.workspace_url
} 

output "workspace_name" {
  value = azurerm_databricks_workspace.databricks.name 
}

output "sp_app_id" {
  value = azuread_application.databricks_app.client_id
}


output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}
output "sp_password" {
  sensitive = true
  value     = azuread_service_principal_password.databricks_sp_password.value
}
output "sp_debug" {
  value = azuread_service_principal.databricks_sp
}