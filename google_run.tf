locals {
  locations = ["europe-west12", "europe-west4"]
}

resource "google_cloud_run_v2_service" "service" {
  provider = google-beta
  for_each = toset(local.locations)

  name     = "service-${each.key}"
  location = each.key

  template {
    scaling {
      max_instance_count = 5
      min_instance_count = 1
    }
    containers {
      image = "gcr.io/${var.my-project}/prenotiamo-image:latest"
      env {
        name  = "SMTP_SERVER"
        value = var.smtp_server
      }
      env {
        name  = "SMTP_USERNAME"
        value = var.smtp_username
      }
      env {
        name  = "MAILTRAP_SECRET"
        value = var.mailtrap_secret
      }
      env {
        name  = "DB_NAME"
        value = var.db_name
      }
      env {
        name  = "DB_SERVICE_USER"
        value = var.db_service_user
      }
      env {
        name  = "DB_HOSTNAME"
        value = google_sql_database_instance.prenotiamo_instance.public_ip_address
      }
      env {
        name  = "DB_SERVICE_USER_PASSWORD"
        value = var.db_service_user_password
      }
      env {
        name  = "DB_SERVICE_ADMIN"
        value = var.db_service_admin
      }
      env {
        name  = "DB_SERVICE_ADMIN_PASSWORD"
        value = var.db_service_admin_password
      }
      env {
        name  = "JWT_SECRET"
        value = var.jwt_secret
      }
      env {
        name  = "COOKIE_NAME"
        value = var.cookie_name
      }
      resources {
        startup_cpu_boost = true
        cpu_idle          = true
        limits = {
          cpu    = "2"
          memory = "2Gi"
        }
      }
      ports {
        container_port = 8080
      }
      liveness_probe {
        http_get {
          path = "/"
        }
        initial_delay_seconds = 150
        failure_threshold     = 5
        timeout_seconds       = 60
        period_seconds        = 60
      }
    }
  }

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }


  depends_on = [
    google_sql_database_instance.prenotiamo_instance
  ]
}

data "google_iam_policy" "noauth" {
  binding {
    role    = "roles/run.invoker"
    members = ["allUsers"]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  for_each = toset(local.locations)

  service     = google_cloud_run_v2_service.service[each.key].name
  location    = google_cloud_run_v2_service.service[each.key].location
  policy_data = data.google_iam_policy.noauth.policy_data
}
