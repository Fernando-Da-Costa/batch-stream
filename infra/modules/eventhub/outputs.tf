output "namespace_id" {
  value = var.namespace_id
}
output "eventhub_connection_string" {
  description = "Connection string para acesso ao Event Hub"
  value       = azurerm_eventhub_namespace_authorization_rule.databricks_access.primary_connection_string
}

output "eventhub_id" {
  value = azurerm_eventhub.this.id
} 

output "eventhub_name" {
  value = azurerm_eventhub.this.name
}
output "eventhub_auth_rule_id" {
  value = azurerm_eventhub_namespace_authorization_rule.databricks_access.id
}

# modules/eventhub/outputs.tf
output "synapse_eh_hub_name" {
  value = azurerm_eventhub.synapse_eh_hub.name
}

output "synapse_eh_auth_id" {
  value = azurerm_eventhub_namespace_authorization_rule.synapse_eh_auth.id
}

