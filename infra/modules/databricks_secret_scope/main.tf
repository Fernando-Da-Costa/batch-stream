##########################################################################################
# Módulo: Databricks Secret Scope
# Cria um escopo de segredo no Databricks vinculado ao Azure Key Vault.
##########################################################################################

resource "databricks_secret_scope" "eventhub_scope" {
  name                     = var.secret_scope_name
  initial_manage_principal = "users"
  keyvault_metadata {
    resource_id = var.keyvault_resource_id
    dns_name    = var.keyvault_dns_name
  }
}
