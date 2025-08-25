terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
    databricks = {
      source  = "databricks/databricks"
    }
    azapi = {
      source  = "azure/azapi"
      version = ">= 1.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "1febf2d4-abff-4d1d-a6ef-6809b4078b8f"
  resource_provider_registrations = "none"

}

provider "azapi" {}

provider "databricks" {
  host                        = var.databricks_host
  azure_workspace_resource_id = var.databricks_workspace_resource_id
}
