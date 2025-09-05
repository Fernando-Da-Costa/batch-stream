##########################################################################################
# Resumo: Prepara um canal de streaming de eventos no Azure para ingestão em tempo real.
##########################################################################################

resource "azurerm_eventhub" "this" {
  name              = var.eventhub_name
  namespace_id      = var.namespace_id      
  partition_count   = 2
  message_retention = 1

}


resource "azurerm_eventhub_namespace_authorization_rule" "databricks_access" {
  name                = "databricks-access"
  namespace_name      = var.namespace_name
  resource_group_name = var.resource_group_name
  listen              = true
  send                = true
  manage              = false
}


##############################################################################################################
resource "azurerm_eventhub_namespace_authorization_rule" "synapse_eh_auth" {
  name                = "synapse-diagnostic-auth"
  namespace_name      = "ehnamespace-synapse-eastus2"
  resource_group_name = var.resource_group_name
  listen              = true
  send                = true
  manage              = false
}

resource "azurerm_eventhub" "synapse_eh_hub" {
  name                = "synapse-logs"
  namespace_id        = var.namespace_synapse_id      
  partition_count     = 2
  message_retention   = 1
}
##############################################################################################################