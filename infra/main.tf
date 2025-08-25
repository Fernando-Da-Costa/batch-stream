module "resource_group" {
  source = "./modules/resource_group"
  name     = var.resource_group_name
  location = var.location
  tags     = local.common_tags
}


# module "eventhub" {
#   source              = "./modules/eventhub"
#   resource_group_name = module.resource_group.name
#   location           = var.location
#   namespace_name     = var.namespace_name
#   eventhub_name      = var.eventhub_name
#   tags               = local.common_tags
# }


# module "keyvault" {
#   source              = "./modules/keyvault"
#   resource_group_name = module.resource_group.name
#   location           = var.location
#   keyvault_name      = var.keyvault_name
#   tags               = local.common_tags
#   eventhub_connection_string = module.eventhub.eventhub_connection_string
# }


module "datalake" {
  source                = "./modules/datalake"
  resource_group_name   = module.resource_group.name
  location              = var.location
  storage_account_name  = var.storage_account_name
  tags                  = local.common_tags
  bronze_group_object_id = "00000000-0000-0000-0000-000000000000" #Mudar depois
  silver_group_object_id = "00000000-0000-0000-0000-000000000000" #Mudar depois
  gold_group_object_id   = "00000000-0000-0000-0000-000000000000" #Mudar depois
}

# Encarregado de jogar os dados dentro do Bronze
module "Azure_data_factory" {
  source                  = "./modules/datafactory"
  resource_group_name     = module.resource_group.name
  location                = var.location
  storage_account_name    = var.storage_account_name
  client_secret           = var.client_secret
  blob_connection_string  = var.blob_connection_string 
  source_file_name        = var.source_file_name 
  tenant_id               = var.tenant_id          
  client_id               = var.client_id           
  source_blob_container   = var.source_blob_container  
  subscription_id         = var.subscription_id
  project_name            = "batch-streaming"          
  databricks_workspace_url  = var.databricks_host
  databricks_token          = var.databricks_token
  databricks_cluster_id     = var.databricks_cluster_id

}



module "databricks" {
  source              = "./modules/databricks"
  resource_group_name = module.resource_group.name
  location            = var.location
  workspace_name      = var.workspace_name
  tags                = local.common_tags
  access_connector_id = module.databricks_access_connector.id
  default_storage_firewall_enabled = false
  storage_account_id  = module.datalake.storage_account_id
  databricks_token    = var.databricks_token
}

# module "aks" {
#   source              = "./modules/aks"
#   resource_group_name = module.resource_group.name
#   location           = var.location
#   cluster_name       = var.cluster_name
#   node_count         = var.node_count
#   vm_size            = var.vm_size
#   environment        = var.environment
# }

# module "acr" {
#   source              = "./modules/acr"
#   resource_group_name = module.resource_group.name
#   location           = var.location
#   acr_name           = var.acr_name
#   tags               = local.common_tags
# }

# module "databricks_secret_scope" {
#   source                = "./modules/databricks_secret_scope"
#   secret_scope_name     = "eventhub-secrets"
#   databricks_host       = module.databricks.workspace_url
#   databricks_token      = var.databricks_token
#   keyvault_resource_id  = module.keyvault.keyvault_id
#   keyvault_dns_name     = module.keyvault.keyvault_uri
#   databricks_workspace_id = "1700375563179521" 
# }


module "databricks_access_connector" {
  source              = "./modules/databricks/databricks_access_connector"
  name                = "databricks-access-connector"
  resource_group_name = module.resource_group.name
  location            = var.location
}

# module "role_assignments" {
#   source                  = "./modules/role_assignments"
#   storage_account_id      = module.datalake.storage_account_id
#   adf_principal_id        = module.Azure_data_factory.adf_principal_id
#   resource_group_name     = module.resource_group.name
#   container_name          = "datalake"
#   databricks_workspace_name = module.databricks.workspace_name
# }



# module "bronze_events_path" {
#   source                      = "./modules/datalake/datalake_path"
#   path_name                   = "bronze/events"
#   filesystem_name             = "datalake"
#   storage_account_id          = module.datalake.storage_account_id
#   managed_identity_object_id  = module.databricks_access_connector.principal_id
#   owner                       = "root"
#   group                       = "root"
#   depends_on = [module.datalake]
# }




