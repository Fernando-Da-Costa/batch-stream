provider "databricks" {
  host  = "https://adb-3150511781092664.4.azuredatabricks.net/"
  token = var.databricks_token
}

resource "databricks_notebook" "bronze" {
  path     = "/Users/fernando.dataclub@outlook.com/Bronze_Access_DataLake"
  language = "PYTHON"
  content_base64 = base64encode(
        file("../consumer/databricks_notebooks/Bronze_Access_DataLake.py")
  )
}


resource "databricks_notebook" "silver" {
  path     = "/Users/fernando.dataclub@outlook.com/Silver_Transformacao"
  language = "PYTHON"
  content_base64 = base64encode(
    file("../consumer/databricks_notebooks/Silver_Transformacao.py")
  )
}


resource "databricks_notebook" "gold" {
  path     = "/Users/fernando.dataclub@outlook.com/Gold_Agregacao"
  language = "PYTHON"
  content_base64 = base64encode(
    file("../consumer/databricks_notebooks/Gold_Agregacao.py")
  )
}
