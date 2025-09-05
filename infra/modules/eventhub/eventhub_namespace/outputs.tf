output "namespace_name" {
  value = azurerm_eventhub_namespace.this.name
}

output "namespace_id" {
  value = azurerm_eventhub_namespace.this.id
}
output "namespace_synapse_id" {
  value = azurerm_eventhub_namespace.synapse_eh.id
}
