variable "storage_account_id" {
  type        = string
  description = "The ID of the storage account to assign the role on"
}

variable "databricks_workspace_name" {
  type        = string
  description = "Nome do workspace Databricks"
}

variable "resource_group_name" {
  type        = string
  description = "Nome do resource group onde está o Databricks"
}


# modules/role_assignments/variables.tf
variable "container_name" {
  description = "Nome do container do Azure Blob Storage"
  type        = string
}

variable "adf_principal_id" {
  description = "Principal ID do Managed Identity do Data Factory"
  type        = string
}

