# VNet dedicada para monitoramento / Flow Logs
resource "azurerm_virtual_network" "flowlog_vnet" {
  name                = "vnet-flowlog"
  address_space       = ["10.1.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Network Watcher já existente na região
data "azurerm_network_watcher" "nw" {
  name                = "NetworkWatcher_eastus"
  resource_group_name = "NetworkWatcherRG"
}

# Log Analytics Workspace
data "azurerm_log_analytics_workspace" "law" {
  name                = "law-batchstreaming"
  resource_group_name = var.resource_group_name
}

# Habilita VNet Flow Logs
resource "azurerm_network_watcher_flow_log" "vnet" {
  name                 = "flowlog-vnet"
  network_watcher_name = data.azurerm_network_watcher.nw.name
  resource_group_name  = data.azurerm_network_watcher.nw.resource_group_name
  target_resource_id   = azurerm_virtual_network.flowlog_vnet.id
  storage_account_id   = var.flowlog_storage_account_id
  enabled              = true

  retention_policy {
    days    = 0
    enabled = false
  }

  traffic_analytics {
    enabled               = true
    workspace_resource_id = data.azurerm_log_analytics_workspace.law.id
    workspace_id          = data.azurerm_log_analytics_workspace.law.workspace_id
    workspace_region      = var.location
  }
}

# Exportação para Log Analytics
resource "azurerm_monitor_diagnostic_setting" "vnet" {
  name                       = "diag-vnet"
  target_resource_id         = azurerm_virtual_network.flowlog_vnet.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.law.id

  enabled_metric {
    category = "AllMetrics"
  }
  depends_on = [azurerm_network_watcher_flow_log.vnet]
}

