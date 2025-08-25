locals {
  blob_dataset_template = {
    "$schema"       = "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#"
    contentVersion  = "1.0.0.0"
    parameters = {
      dataFactoryName   = { type = "string" }
      sourceContainer   = { type = "string" }
      sourceFileName    = { type = "string" }
      destinationFolder = { type = "string" }
    }
    resources = [
      {
        type       = "Microsoft.DataFactory/factories/datasets"
        apiVersion = "2018-06-01"
        name       = "[concat(parameters('dataFactoryName'), '/BlobDataset')]"
        properties = {
          type              = "AzureBlob"
          linkedServiceName = {
            referenceName = "ls_blobsource"
            type          = "LinkedServiceReference"
          }
          typeProperties = {
            folderPath = "[parameters('destinationFolder')]"
            fileName   = "[parameters('sourceFileName')]"
            format     = {
              type = "TextFormat"
            }
          }
        }
      }
    ]
  }
}
