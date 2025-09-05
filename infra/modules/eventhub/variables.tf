
variable "namespace_name" {
  description = "Name of the Event Hub Namespace"
  type        = string
}

variable "eventhub_name" {
  description = "Name of the Event Hub"
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

variable "namespace_id" {
  description = "ID of the Event Hub Namespace"
  type        = string
}

variable "namespace_synapse_id" {
  description = "ID of the Event Hub Namespace"
  type        = string
}