module "datadog_sa" {
  source  = "terraform-google-modules/service-accounts/google"
  version = "~> 3.0"

  project_id = var.project_id
  names      = ["datadog-sa"]
  project_roles = [
    "${var.project_id}=>roles/browser",
    "${var.project_id}=>roles/monitoring.viewer",
    "${var.project_id}=>roles/compute.viewer",
    "${var.project_id}=>roles/cloudasset.viewer",
    "${var.project_id}=>roles/logging.logWriter",
  ]

  display_name = "DataDog Service Account"
}

resource "google_service_account_key" "datadog" {
  service_account_id = module.datadog_sa.email

  depends_on = [module.datadog_sa]
}

resource "datadog_integration_gcp" "awesome_gcp_project_integration" {
  project_id     = jsondecode(base64decode(google_service_account_key.datadog.private_key))["project_id"]
  private_key    = jsondecode(base64decode(google_service_account_key.datadog.private_key))["private_key"]
  private_key_id = jsondecode(base64decode(google_service_account_key.datadog.private_key))["private_key_id"]
  client_email   = jsondecode(base64decode(google_service_account_key.datadog.private_key))["client_email"]
  client_id      = jsondecode(base64decode(google_service_account_key.datadog.private_key))["client_id"]

  depends_on = [google_service_account_key.datadog]
}