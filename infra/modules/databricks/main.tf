data "azurerm_client_config" "current" {}


# Criar o Service Principal
resource "azuread_application" "databricks_app" {
  display_name = "sp-databricks-datalake"
}
resource "azuread_service_principal" "databricks_sp" {
  client_id  = azuread_application.databricks_app.client_id  
}


resource "random_password" "sp_password" {
  length  = 16
  special = true
}
resource "azuread_service_principal_password" "databricks_sp_password" {
  service_principal_id = azuread_service_principal.databricks_sp.id
  end_date             = timeadd(timestamp(), "8760h") # 1 ano a partir de agora
  # Observação: O valor da senha será gerado automaticamente pelo Azure AD
}



# Atribuir role no Storage Account para o SP
resource "azurerm_role_assignment" "databricks_sp_role" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azuread_service_principal.databricks_sp.object_id  
}



resource "azurerm_databricks_workspace" "databricks" {
  name                = var.workspace_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "premium"
  tags                = var.tags
  access_connector_id = var.access_connector_id
  default_storage_firewall_enabled = false
}



# Criando os notebooks.
module "databricks_notebooks" {
  source            = "./databricks_notebook"
  databricks_token  = var.databricks_token
}
