variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "location" {
  description = "Azure region where the AKS cluster will be created"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group where the AKS cluster will be created"
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

variable "environment" {
  description = "Environment (dev, qa, prod)"
  type        = string
}

