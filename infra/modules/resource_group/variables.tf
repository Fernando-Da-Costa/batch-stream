variable "name" {
  description = "Name of the Azure resource group. Must be between 1 and 90 characters."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 90
    error_message = "The resource group name must be between 1 and 90 characters."
  }
}
variable "location" {
  description = "Azure region where the resource group will be created"
  type        = string
  default     = "eastus"

  validation {
    condition = contains([
      "eastus", "westus", "centralus", "brazilsouth", "northeurope", "westeurope",
      "southeastasia", "eastasia", "japaneast", "japanwest", "australiaeast", "australiasoutheast"
    ], var.location)
    error_message = "Location must be a valid Azure region."
  }
}
variable "tags" {
  description = "Tags to be applied to the resource group"
  type        = map(string)
  default     = {}
}
