##################################################################################################
#Resumo: Provisiona um cluster Kubernetes gerenciado para orquestração de contêineres no Azure.
#################################################################################################
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.cluster_name
  kubernetes_version  = "1.27.102"
  sku_tier            = "Premium"
  support_plan        = "AKSLongTermSupport"

  default_node_pool {
    name            = "default"
    node_count      = var.node_count
    vm_size         = "Standard_D2s_v3"
    os_disk_size_gb = 30
    type            = "VirtualMachineScaleSets"
  }

  network_profile {
    network_plugin = "kubenet"
    load_balancer_sku = "standard"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment     = var.environment
    ManagedBy      = "Terraform"
    Project        = "BatchStreaming"
    CostCenter     = "DataEngineering"
    DataClassification = "Internal"
  }
}

