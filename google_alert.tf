resource "google_monitoring_alert_policy" "cloud_run_alert_policy" {
  provider = google-beta
  for_each = toset(local.locations)

  display_name = "Cloud Run Errors ${each.key}"
  combiner     = "OR"

  conditions {
    display_name = "High number of server errors"
    condition_threshold {
      filter          = "metric.type=\"run.googleapis.com/request_count\" AND resource.type=\"cloud_run_revision\" AND metric.label.response_code_class=\"5xx\" AND metadata.user_labels.\"cloud.googleapis.com/location\"=\"${each.key}\""
      duration        = "300s"
      comparison      = "COMPARISON_GT"
      threshold_value = 10
      trigger {
        count = 1
      }
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }

  notification_channels = [
    google_monitoring_notification_channel.email.name,
  ]
  depends_on = [
    google_cloud_run_v2_service.service
  ]
}

resource "google_monitoring_alert_policy" "cloud_run_latency" {
  provider     = google-beta
  for_each     = toset(local.locations)
  display_name = "Cloud Run Latency Alert ${each.key}"
  combiner     = "OR"

  conditions {
    display_name = "Latency exceeds 300ms"

    condition_threshold {
      filter     = "metric.type=\"run.googleapis.com/request_latencies\" resource.type=\"cloud_run_revision\" AND metadata.user_labels.\"cloud.googleapis.com/location\"=\"${each.key}\""
      duration   = "60s"
      comparison = "COMPARISON_GT"

      threshold_value = 0.3
      trigger {
        count = 1
      }

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_PERCENTILE_99"
      }
    }
  }

  notification_channels = [
    google_monitoring_notification_channel.email.name
  ]
  depends_on = [
    google_cloud_run_v2_service.service
  ]
}

resource "google_monitoring_alert_policy" "cloud_sql_cpu" {
  display_name = "Cloud SQL CPU Alert"
  combiner     = "OR"

  conditions {
    display_name = "CPU utilization exceeds 90%"

    condition_threshold {
      filter     = "metric.type=\"cloudsql.googleapis.com/database/cpu/utilization\" resource.type=\"cloudsql_database\""
      duration   = "300s"
      comparison = "COMPARISON_GT"

      threshold_value = 0.9
      trigger {
        count = 1
      }
    }
  }

  notification_channels = [
    google_monitoring_notification_channel.email.name
  ]
}


resource "google_monitoring_notification_channel" "email" {
  display_name = "Email"
  type         = "email"
  labels = {
    email_address = "gerardo.cipriano@studio.unibo.it"
  }
}
