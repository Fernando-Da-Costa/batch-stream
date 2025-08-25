output "adf_principal_id" {
  value       = module.Azure_data_factory.adf_principal_id
  description = "Principal ID do Managed Identity do Data Factory"
}
