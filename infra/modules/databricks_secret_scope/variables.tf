variable "secret_scope_name" {
  description = "Nome do Secret Scope no Databricks"
  type        = string
}

variable "databricks_host" {
  description = "URL do workspace Databricks"
  type        = string
}

variable "databricks_token" {
  description = "Token de acesso ao Databricks"
  type        = string
  sensitive   = true
}

variable "keyvault_resource_id" {
  description = "Resource ID do Key Vault"
  type        = string
}

variable "keyvault_dns_name" {
  description = "DNS do Key Vault (vault URI)"
  type        = string
}

variable "databricks_workspace_id" {
  description = "ID do workspace Databricks"
  type        = string
}
