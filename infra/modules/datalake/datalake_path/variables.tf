variable "path_name" {
  description = "Nome do diretório a ser criado"
  type        = string
}

variable "filesystem_name" {
  description = "Nome do contêiner do Data Lake"
  type        = string
}

variable "storage_account_id" {
  description = "ID do Storage Account"
  type        = string
}

variable "managed_identity_object_id" {
  description = "Object ID da identidade gerenciada que terá acesso"
  type        = string
}


variable "owner" {
  description = "Owner of the ADLS Gen2 path"
  type        = string
}

variable "group" {
  description = "Group of the ADLS Gen2 path"
  type        = string
}
