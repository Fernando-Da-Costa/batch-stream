variable "workspace_name" {
  description = "Name of the Databricks workspace"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
}

variable "access_connector_id" {
  type        = string
  description = "ID do Access Connector para o Databricks"
}

variable "default_storage_firewall_enabled" {
  type        = bool
  description = "Habilita o firewall de armazenamento padrão"
  default     = false
}

variable "storage_account_id" {
  description = "ID do Storage Account para atribuição de role"
  type        = string
}

variable "databricks_token" {
  description = "Token de autenticação do Databricks"
  type        = string
  sensitive   = true
} 
