resource "azurerm_resource_provider_registration" "synapse" {
  name = "Microsoft.Synapse"
}

# Module: synapse_workspace
resource "azurerm_synapse_workspace" "workspace" {
  name                                 = var.workspace_name
  resource_group_name                  = var.resource_group
  location                             = "eastus2"
  storage_data_lake_gen2_filesystem_id = var.adls_filesystem_id
  sql_administrator_login              = var.sql_admin_user
  sql_administrator_login_password     = var.sql_admin_password

  identity {
    type = "SystemAssigned"
  }
  depends_on = [azurerm_resource_provider_registration.synapse]

}


# Serverless SQL Pool não precisa criar, ele vem por default no workspace
# Apenas criar firewall rule se necessário
resource "azurerm_synapse_firewall_rule" "allow_my_ip" {
  name                = "allow_my_ip"
  synapse_workspace_id = azurerm_synapse_workspace.workspace.id
  start_ip_address    = var.my_ip
  end_ip_address      = var.my_ip
}
