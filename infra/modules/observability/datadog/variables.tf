variable "datadog_monitor_name" {
  type        = string
  description = "Nome do monitor Datadog no Azure"
}


variable "log_analytics_id" {
  type        = string
  description = "ID do Log Analytics já centralizado"
}

variable "datadog_api_key" {
  type        = string
  description = "API Key do Datadog"
  sensitive   = true
}

variable "datadog_app_key" {
  type        = string
  description = "Application Key do Datadog"
  sensitive   = true
}
