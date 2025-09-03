variable "log_analytics_name" {
  type        = string
  description = "Nome do Log Analytics Workspace"
}

variable "location" {
  type        = string
  description = "Localização dos recursos"
}

variable "resource_group_name" {
  type        = string
  description = "Nome do Resource Group"
}

variable "synapse_id" {
  type        = string
  description = "ID do Synapse Workspace"
}

variable "databricks_id" {
  type        = string
  description = "ID do Databricks Workspace"
}

variable "datalake_id" {
  type        = string
  description = "ID do Data Lake Gen2"
}
