####################################################################################################################################
# Cria o Datadog Monitor no Azure e conecta o Log Analytics para enviar métricas e logs.
# Assim, todo o Lakehouse (dados + rede) chega no Datadog via camada central de observabilidade.
####################################################################################################################################
terraform {
  required_providers {
    datadog = {
      source  = "datadog/datadog"
      version = "~> 3.72.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
 
}

resource "datadog_monitor" "batchstreaming" {
  name    = "dd-monitor-batchstreaming"
  type    = "metric alert"  
  query   = "avg(last_5m):avg:azure.databricks.jobs.run.duration{*} > 300"
  message = "Atenção! Job demorou mais que 5 minutos."
  tags    = ["environment:dev", "team:batch"]
  notify_no_data = true
  renotify_interval = 60
}
