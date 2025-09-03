variable "environment" {
  description = "Environment (dev, qa, prod)"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "keyvault_name" {
  description = "Name of the Key Vault"
  type        = string
}

variable "subscription_id" {
  type        = string
  description = "ID da assinatura do Azure"
} 

variable "namespace_name" {
  description = "Name of the Event Hub Namespace"
  type        = string
}
variable "eventhub_name" {
  description = "Name of the Event Hub"
  type        = string
}

variable "workspace_name" {
  description = "Name of the Databricks Workspace"
  type        = string
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "node_count" {
  description = "Number of nodes in the AKS cluster"
  type        = number
}

variable "vm_size" {
  description = "Size of the VM for AKS nodes"
  type        = string
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
}


variable "databricks_token" {
  description = "Token de acesso pessoal do Databricks"
  type        = string
  sensitive   = true
}
variable "databricks_workspace_id" {
  description = "ID do workspace Databricks"
  type        = string
}


variable "databricks_host" {
  description = "URL do workspace Databricks"
  type        = string
}

variable "databricks_workspace_resource_id" {
  description = "Resource ID do workspace Databricks"
  type        = string
}

variable "client_secret" {
  type = string
  description = "Segredo do Service Principal usado para autenticação"
  sensitive = true
}

variable "storage_account_name" {
  type        = string
  description = "Nome da conta de armazenamento usada no Data Lake"
}

variable "blob_connection_string" {
  type        = string
  description = "Connection string do Blob Storage"
  sensitive   = true
}

variable "source_file_name" {
  type        = string
  description = "Nome do arquivo de origem no blob"
}

variable "tenant_id" {
  type        = string
  description = "ID do tenant do Azure"
}

variable "client_id" {
  type        = string
  description = "ID do Service Principal"
}

variable "source_blob_container" {
  type        = string
  description = "Nome do container onde o arquivo de origem está armazenado"
}

variable "databricks_cluster_id" {
  type        = string
  description = "ID do cluster existente no Databricks (ou vazio para criar newCluster)"
  default     = ""
}

variable "nsg_id" {
  type        = string
  description = "ID do Network Security Group"
}

variable "service_principal_object_id" {
  type        = string
  description = "Object ID do Service Principal"
}

variable "datadog_app_key" {
  type        = string
  description = "App Key do Datadog"
}

variable "datadog_api_key" {
  type        = string
  description = "API Key do Datadog"
}