
locals {
  common_tags = {
    Environment     = var.environment
    ManagedBy      = "Terraform"
    Project        = "BatchStreaming"
    CostCenter     = "DataEngineering"
    DataClassification = "Internal"
  }
}