output "adf_principal_id" {
  value = azurerm_data_factory.adf.identity[0].principal_id
  description = "Principal ID do Managed Identity do Data Factory"
}

