module "resource_group" {
  source = "./modules/resource_group"
  name     = var.resource_group_name
  location = var.location
  tags     = local.common_tags
}


################################################################################################################
# Criando a namespace
module "eventhub_namespace" {
  source              = "./modules/eventhub/eventhub_namespace"
  resource_group_name = module.resource_group.name
  location            = var.location
  namespace_name      = var.namespace_name
  tags                = local.common_tags
}
# Lista de Event Hubs
locals {
  eventhub = {
    streaming  = var.eventhub_name
    databricks = var.eventhub_name_databricks
    synapse    = "synapse-logs"
  }
}
# Criando Event Hubs com for_each
module "eventhub" {
  source              = "./modules/eventhub"
  for_each            = local.eventhub
  resource_group_name = module.resource_group.name
  location            = var.location
  namespace_name      = module.eventhub_namespace.namespace_name
  namespace_id        = module.eventhub_namespace.namespace_id
  namespace_synapse_id        = module.eventhub_namespace.namespace_synapse_id
  eventhub_name       = each.value
  tags                = local.common_tags
}
################################################################################################################################


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


# Criando workspace, firewall e external table para consultar Parquet
module "synapse" {
  source              = "./modules/synapse_workspace"
  workspace_name      = var.workspace_name
  resource_group      = module.resource_group.name
  location            = var.location
  adls_filesystem_id  = module.datalake.adls_filesystem_id
  sql_admin_user      = "sqladmin"
  sql_admin_password  = "SuperSecret123!"
  my_ip               = "200.149.56.197" 
}



# Logs centrais (Log Analytics, Data Lake, Synapse, Databricks)
module "observability_core" {
  source              = "./modules/observability/core"
  log_analytics_name  = "law-batchstreaming"
  location            = var.location
  resource_group_name = module.resource_group.name
  synapse_id          = module.synapse.workspace_id
  databricks_id       = module.databricks.workspace_id
  datalake_id         = module.datalake.storage_account_id
  datadog_api_key     = var.datadog_api_key
  datadog_app_key     = var.datadog_app_key
  eventhub_name                  = module.eventhub["databricks"].eventhub_name
  eventhub_authorization_rule_id = module.eventhub["streaming"].eventhub_auth_rule_id
  eventhub_name_synapse          = module.eventhub["synapse"].synapse_eh_hub_name
  eventhub_authorization_rule_synapse_id = module.eventhub["synapse"].synapse_eh_auth_id

}





# Tirar depois da aqui.
resource "azurerm_role_assignment" "nsg_write_access" {
  scope                = var.nsg_id
  role_definition_name = "Network Contributor"
  principal_id         = var.service_principal_object_id
}



# Logs centrais Firewall, NSG, VNet Flow Logs
module "observability_network" {
  source                      = "./modules/observability/network"
  log_analytics_id            = module.observability_core.log_analytics_id
  nsg_id                      = var.nsg_id
  resource_group_name         = var.resource_group_name     
  location                    = var.location                
  flowlog_storage_account_id  = module.datalake.storage_account_id 
}



# Integração com Datadog
module "observability_datadog" {
  source               = "./modules/observability/datadog"
  datadog_monitor_name = "dd-monitor-batchstreaming"
  log_analytics_id     = module.observability_core.log_analytics_id
  datadog_api_key = var.datadog_api_key
  datadog_app_key = var.datadog_app_key
}


# Cria um dashboard e monitores no Datadog para centralizar métricas e logs do seu Lakehouse (Synapse, Databricks, ADLS) filtrados por resource_group e env
module "observability_dd_dashboard" {
  source              = "./modules/observability/datadog_dashboard"
  resource_group_name = module.resource_group.name
  env                 = var.environment
  datadog_api_key     = var.datadog_api_key
  datadog_app_key     = var.datadog_app_key 
}
