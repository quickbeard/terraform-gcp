resource "google_monitoring_notification_channel" "email_channel" {
  for_each     = toset([var.project_id, "security-376019"])
  project      = each.value
  type         = "email"
  display_name = "Email Notifications"
  labels = {
    email_address = var.email
  }
}

resource "google_monitoring_alert_policy" "resources_utilization_alert" {
  project               = var.project_id
  combiner              = "OR"
  display_name          = "Resources Utilization"
  notification_channels = [google_monitoring_notification_channel.email_channel[var.project_id].id]

  for_each = {
    "GCE Instance - CPU Utilization" : "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" resource.type=\"gce_instance\""
    "CloudSQL DB - CPU Utilization" : "metric.type=\"cloudsql.googleapis.com/database/cpu/utilization\" resource.type=\"cloudsql_database\""
    "CloudSQL DB - Memory Utilization" : "metric.type=\"cloudsql.googleapis.com/database/memory/utilization\" resource.type=\"cloudsql_database\""
    "CloudSQL DB - Disk Utilization" : "metric.type=\"cloudsql.googleapis.com/database/disk/utilization\" resource.type=\"cloudsql_database\""
  }

  conditions {
    display_name = each.key
    condition_threshold {
      filter          = each.value
      duration        = "300s"
      comparison      = "COMPARISON_GT"
      threshold_value = var.utilization_threshold_value
      trigger {
        count = 1
      }
    }
  }
}

resource "google_monitoring_alert_policy" "disk_io_counts_alert" {
  project               = var.project_id
  combiner              = "OR"
  display_name          = "Disk IO Counts"
  notification_channels = [google_monitoring_notification_channel.email_channel[var.project_id].id]

  for_each = {
    "CloudSQL DB - Disk Read IO" : "metric.type=\"cloudsql.googleapis.com/database/disk/read_ops_count\" resource.type=\"cloudsql_database\""
    "CloudSQL DB - Disk Write IO" : "metric.type=\"cloudsql.googleapis.com/database/disk/write_ops_count\" resource.type=\"cloudsql_database\""
  }

  conditions {
    display_name = each.key
    condition_threshold {
      filter          = each.value
      duration        = "300s"
      comparison      = "COMPARISON_GT"
      threshold_value = var.count_threshold_value
      trigger {
        count = 1
      }
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }
}

resource "google_logging_metric" "ids_logging_metric" {
  for_each = toset([var.project_id, "security-376019"])
  project  = each.value
  name     = "ids-logging"
  filter   = "logName=\"projects/endue-staging-263b/logs/ids.googleapis.com%2Fthreat\" AND resource.type=\"ids.googleapis.com/Endpoint\" AND jsonPayload.alert_severity=(\"HIGH\" OR \"CRITICAL\")"
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }
}

resource "google_monitoring_alert_policy" "ids_logging_alert" {
  for_each              = toset([var.project_id, "security-376019"])
  project               = each.value
  display_name          = "IDS Logging"
  combiner              = "OR"
  notification_channels = [google_monitoring_notification_channel.email_channel[each.value].id]

  conditions {
    display_name = "Threats in IDS Log"
    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/${google_logging_metric.ids_logging_metric[each.value].id}\" resource.type=\"ids.googleapis.com/Endpoint\""
      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0
    }
  }
}