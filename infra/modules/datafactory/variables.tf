variable "location" {}
variable "resource_group_name" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "storage_account_name" {}
variable "blob_connection_string" {}
variable "source_blob_container" {}
variable "source_file_name" {}
variable "subscription_id" {
  type        = string
  description = "ID da assinatura do Azure"
}
variable "project_name" {}

variable "databricks_workspace_url" {
  type        = string
  description = "URL do workspace Databricks, ex: adb-1234567890123456.7.azuredatabricks.net"
}

variable "databricks_token" {
  type        = string
  description = "Token de acesso ao Databricks (ou via Key Vault)"
  sensitive   = true
}

variable "databricks_cluster_id" {
  type        = string
  description = "ID do cluster existente no Databricks (ou vazio para criar newCluster)"
  default     = ""
}

