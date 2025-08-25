
variable "storage_account_name" {
  description = "Name of the storage account"
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

variable "bronze_group_object_id" {
  description = "Object ID of the bronze group"
  type        = string
}

variable "silver_group_object_id" {
  description = "Object ID of the silver group"
  type        = string
}

variable "gold_group_object_id" {
  description = "Object ID of the gold group"
  type        = string
}


