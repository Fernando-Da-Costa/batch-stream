##########################################################################################
# Resumo: Prepara um canal de streaming de eventos no Azure para ingestão em tempo real.
##########################################################################################
resource "azurerm_eventhub_namespace" "eventhub" {
  name                = var.namespace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  capacity            = 1
  tags                = var.tags
}

resource "azurerm_eventhub" "eventhub" {
  name              = var.eventhub_name
  namespace_id      = azurerm_eventhub_namespace.eventhub.id
  partition_count   = 2
  message_retention = 1
}

resource "azurerm_eventhub_namespace_authorization_rule" "databricks_access" {
  name                = "databricks-access"
  namespace_name      = azurerm_eventhub_namespace.eventhub.name
  resource_group_name = var.resource_group_name
  listen              = true
  send                = true
  manage              = false
}