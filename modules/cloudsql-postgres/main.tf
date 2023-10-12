resource "random_password" "cloudsql_db_password" {
  length  = 14
  special = false
}

module "cloudsql_postgresql" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version = "~> 14.0"

  project_id          = var.project_id
  database_version    = var.database_version
  zone                = var.zone
  tier                = var.db_tier
  activation_policy   = "ALWAYS"
  deletion_protection = var.deletion_protection
  create_timeout      = "45m"
  update_timeout      = "45m"
  user_name           = var.db_user_name
  name                = var.db_instance_name
  user_password       = random_password.cloudsql_db_password.result

  database_flags = [
    {
      name  = "max_locks_per_transaction"
      value = var.max_locks_per_transaction
    },
  ]

  ip_configuration = {
    allocated_ip_range  = var.db_ip_range
    authorized_networks = []
    ipv4_enabled        = false
    private_network     = var.private_network
    require_ssl         = false
  }

  backup_configuration = {
    enabled                        = true
    start_time                     = "05:00" # 5 am
    location                       = "us"
    retained_backups               = var.retained_backups               # this should depends on which env, prod should have more backup ver than others
    retention_unit                 = "COUNT"                            # default
    point_in_time_recovery_enabled = var.point_in_time_recovery_enabled # This will allow us to recover db in case of crash, in non-prod env this can be false, but in prod this should be true
    transaction_log_retention_days = var.transaction_log_retention_days # same with the retained_backups count
  }
}

resource "google_secret_manager_secret" "cloudsql_db_password_secret" {
  project   = var.project_id
  secret_id = var.db_password

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret" "cloudsql_db_url_secret" {
  project   = var.project_id
  secret_id = var.db_url

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "cloudsql_db_password_secret_version" {
  secret      = google_secret_manager_secret.cloudsql_db_password_secret.id
  secret_data = random_password.cloudsql_db_password.result
}

resource "google_secret_manager_secret_version" "cloudsql_db_url_secret_version" {
  secret      = google_secret_manager_secret.cloudsql_db_url_secret.id
  secret_data = join("", ["postgresql://postgres:", random_password.cloudsql_db_password.result, "@", module.cloudsql_postgresql.private_ip_address, ":", var.db_port, "/", var.db_name])
}
