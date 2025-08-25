
output "namespace_id" {
  value = azurerm_eventhub_namespace.eventhub.id
}

output "eventhub_id" {
  value = azurerm_eventhub.eventhub.id
} 

output "eventhub_connection_string" {
  description = "Connection string para acesso ao Event Hub"
  value       = azurerm_eventhub_namespace_authorization_rule.databricks_access.primary_connection_string
}
