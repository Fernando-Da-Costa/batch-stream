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


resource "datadog_dashboard" "lakehouse" {
  title       = "Lakehouse – Observability (Synapse/Databricks/ADLS)"
  description = "Visão unificada de dados + rede via Azure → Datadog"
  layout_type = "ordered"

  # Filtros rápidos
  template_variable {
    name     = "rg"
    prefix   = "resource_group"
    defaults = [var.resource_group_name]
  }

  template_variable {
    name     = "ws"
    prefix   = "resource_name"
    defaults = ["*"]
  }

  # Logs de erro por serviço
  widget {
  log_stream_definition {
    title               = "Logs de erro por serviço"
    query               = "status:error source:azure resource_group:$rg resource_name:$ws"
    message_display     = "inline"
    show_date_column    = true
    show_message_column = true

    sort {
      column = "time"
      order  = "desc"
    }
  }
}


# Latência ADLS (logs de Storage)
widget {
  query_value_definition {
    title = "ADLS: operações com falha (5 min)"
    request {
          q = "avg:system.cpu.user{*}"
    }
  }
}



  # # Synapse: falhas de query (logs)
  widget {
  log_stream_definition {
    title               = "Synapse: falhas de SQL (por motivo)"
    query               = "status:error source:azure resource_provider:Microsoft.Synapse operation_name:*Query* resource_group:{{rg}} resource_name:{{ws}}"
    message_display     = "inline"
    show_date_column    = true
    show_message_column = true

    sort {
      column = "time"
      order  = "desc"
      }
    }
  }


  # Databricks: jobs com erro (logs)
  widget {
  log_stream_definition {
    title               = "Databricks: Jobs com erro"
    query               = "status:error source:azure resource_provider:Microsoft.Databricks resource_group:$rg resource_name:$ws"
    message_display     = "inline"
    show_date_column    = true
    show_message_column = true

    sort {
      column = "time"
      order  = "desc"
    }
  }
}


  # Activity: mudanças recentes
  widget {
  event_stream_definition {
    title          = "Azure Activity (últimas 24h)"
    query          = "source:azure resource_group:{{rg}} resource_name:{{ws}}"
    tags_execution = "and"
  }
}


  # Monitores em aberto
  widget {
    alert_graph_definition {
      title    = "Alertas relacionados (ativos)"
      viz_type = "timeseries"
      alert_id = "*"
    }
  }
}

