locals {
  cert_manager_perms = [
    "dns.resourceRecordSets.*",
    "dns.changes.*",
    "dns.managedZones.list"
  ]
}

resource "google_project_iam_custom_role" "main" {
  role_id     = "certManagerRole"
  title       = "CertManager Role"
  description = "This role is to support Cert Manager manage certs"
  permissions = local.cert_manager_perms
  project     = var.project_id
}

module "cert_manager_sa" {
  source  = "terraform-google-modules/service-accounts/google"
  version = "~> 3.0"

  project_id = var.project_id
  names      = ["dns01-solver"]
  project_roles = [
    "${var.project_id}=>projects/${var.project_id}/roles/certManagerRole",
  ]

  display_name = "Cert Manager GCP Service Account"
  depends_on   = [google_project_iam_custom_role.main]
}

