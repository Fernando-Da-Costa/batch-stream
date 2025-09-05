
resource "azurerm_eventhub_namespace" "this" {
  name                = var.namespace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  capacity            = 1
  tags                = var.tags
}



# Mudar depois da aqui, isso é apenas para teste.
##################################################################################################################################
resource "azurerm_eventhub_namespace" "synapse_eh" {
  name                = "ehnamespace-synapse-eastus2"
  location            = "eastus2"
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  capacity            = 1
  tags                = var.tags
}
##################################################################################################################################