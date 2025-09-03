terraform {
  required_providers {
    datadog = {
      source  = "datadog/datadog"
      version = "~> 3.72.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}



# Cria um Log Analytics Workspace (central de logs)
resource "azurerm_log_analytics_workspace" "this" {
  name                = var.log_analytics_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}


# Configura diagnóstico para Synapse
resource "azurerm_monitor_diagnostic_setting" "synapse" {
  name                       = "diag-synapse"
  target_resource_id         = var.synapse_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  enabled_log {
    category = "GatewayApiRequests"
  }
  enabled_metric {
    category = "AllMetrics"
  }
}


# Configura diagnóstico para Databricks enviando ao Event Hub
resource "azurerm_monitor_diagnostic_setting" "databricks" {
  name                            = "diag-databricks"
  target_resource_id              = var.databricks_id
  eventhub_name                   = var.eventhub_name
  eventhub_authorization_rule_id  = var.eventhub_authorization_rule_id


  dynamic "enabled_log" {
    for_each = toset([
      "Clusters", "Jobs", "DBFS", "Accounts", "SSH", "Workspace", "Secrets"
    ])
    content {
      category = enabled_log.value
    }
  }
}



# Configura diagnóstico para Data Lake
# Logs que quero habilitar
resource "azurerm_monitor_diagnostic_setting" "datalake" {
  name                       = "diag-datalake"
  target_resource_id         = var.datalake_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  # Só métricas são suportadas
  enabled_metric {
    category = "AllMetrics"
  }
}

data "azurerm_log_analytics_workspace" "law" {
  name                = var.log_analytics_name
  resource_group_name = var.resource_group_name
}


resource "datadog_logs_metric" "minha_metrica" {
  name = "custom.app.erros"

  compute {
    aggregation_type = "count"
  }

  filter {
    query = "source:app status:error"
  }

  group_by {
    path     = "@service"
    tag_name = "service"
  }
}

