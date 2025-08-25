output "secret_scope_name" {
  description = "Nome do Secret Scope criado no Databricks"
  value       = databricks_secret_scope.eventhub_scope.name
}
