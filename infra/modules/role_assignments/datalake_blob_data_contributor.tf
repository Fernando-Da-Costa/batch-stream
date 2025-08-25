resource "azurerm_role_assignment" "adf_blob_contributor" {
  scope                = "${var.storage_account_id}/blobServices/default/containers/datalake"
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.adf_principal_id
}
