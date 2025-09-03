variable "log_analytics_id" {
  type        = string
  description = "ID do Log Analytics Workspace"
}


variable "nsg_id" {
  type        = string
  description = "ID do Network Security Group"
}

variable "flowlog_storage_account_id" {
  type        = string
  description = "ID da conta de armazenamento para armazenar os logs de fluxo"
}

variable "location" {
  type        = string
  description = "Localização da rede virtual"
}

variable "resource_group_name" {
  type        = string
  description = "Nome do grupo de recursos"
}

