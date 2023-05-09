# Imposta l'istanza del database SQL
resource "google_sql_database_instance" "prenotiamo_instance" {
  name              = "prenotiamo-instance"
  database_version  = "MYSQL_5_7"
  region            = "asia-east1"
  deletion_protection = false

  settings {
    tier = "db-f1-micro"
    availability_type = "REGIONAL"

    backup_configuration {
      binary_log_enabled = true
      enabled            = true
    }

    ip_configuration {
      require_ssl     = false
      ipv4_enabled    = true
      authorized_networks {
        value           = "0.0.0.0/0"
        name            = "all"
        expiration_time = null
      }
    }

    database_flags {
      name  = "wait_timeout"
      value = "300"
    }

    database_flags {
      name  = "max_connections"
      value = "1000"
    }
  }
}


# Imposta l'utente del servizio per accedere al database
resource "google_sql_user" "service_user" {
  project = var.my-project
  name     = "prenotiamo_svc_ws"
  instance = google_sql_database_instance.prenotiamo_instance.name
  password = var.db_service_user_password
  host = "%"

    depends_on = [
    google_sql_database_instance.prenotiamo_instance
  ]
}

# Imposta l'utente amministratore del servizio per accedere al database
resource "google_sql_user" "admin_user" {
  project = var.my-project
  name     = "prenotiamo_svcadm_ws"
  instance = google_sql_database_instance.prenotiamo_instance.name
  password = var.db_service_admin_password
  host = "%"

  depends_on = [
    google_sql_database_instance.prenotiamo_instance
  ]
}

# Inizializza il database
resource "null_resource" "populate_db" {
  depends_on = [
    google_sql_user.admin_user,
  ]

  provisioner "local-exec" {
    command = "mysql --host=${google_sql_database_instance.prenotiamo_instance.public_ip_address} --user=${google_sql_user.admin_user.name} --password=${google_sql_user.admin_user.password} < script.sql"
  }
}