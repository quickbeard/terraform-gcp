resource "google_secret_manager_secret" "gke_secrets" {
  project   = var.project_id
  secret_id = var.secret_id

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "gke_secrets_version" {
  secret      = google_secret_manager_secret.gke_secrets.id
  secret_data = var.secret_data
}