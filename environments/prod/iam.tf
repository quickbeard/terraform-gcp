module "accounts_roles" {
  source = "../../modules/security"

  org_id     = var.org_id
  project_id = module.prod_project.project_id

  # Workload Identity
  ksa = {
    webapp           = "webapp-sa"
    fhir-server      = "fhir-sa"
    external-secrets = "secret-store-sa"
  }
  workload_identity_roles = [
    "roles/cloudsql.editor",
    "roles/secretmanager.secretAccessor",
  ]

  # Default SA roles
  default_sa = [
    "serviceAccount:project-service-account@${module.prod_project.project_id}.iam.gserviceaccount.com",
  ]
  default_sa_roles = [
    "roles/artifactregistry.reader",
    "roles/artifactregistry.writer",
  ]

  # Engineers roles
  engs = [
    "group:eng@enduesoftware.com",
  ]
  eng_roles = [
    "roles/storage.admin",
    "roles/artifactregistry.reader",
    "roles/dns.reader",
    "roles/documentai.viewer",
    "roles/errorreporting.user",
    "roles/ids.viewer",
    "roles/logging.viewer",
    "roles/monitoring.alertPolicyViewer",
  ]

  # Admin roles
  admins = [
    "serviceAccount:terraform-sa@security-376019.iam.gserviceaccount.com",
  ]
  admin_roles = [
    "roles/artifactregistry.admin",
    "roles/cloudsql.admin",
    "roles/container.admin",
    "roles/dns.admin",
    "roles/documentai.admin",
    "roles/errorreporting.admin",
    "roles/iam.serviceAccountTokenCreator",
    "roles/ids.admin",
    "roles/logging.admin",
    "roles/monitoring.admin",
    "roles/resourcemanager.projectIamAdmin",
    "roles/secretmanager.admin",
    "roles/servicenetworking.networksAdmin",
  ]

  devops = [
    "group:devops@enduesoftware.com",
    "serviceAccount:terraform-sa@security-376019.iam.gserviceaccount.com",
  ]

  devops_roles = [
    "roles/artifactregistry.admin",
    "roles/container.admin",
    "roles/compute.networkAdmin",
    "roles/logging.admin",
    "roles/monitoring.admin",
    "roles/iam.serviceAccountTokenCreator",
    "roles/ids.admin",
    "roles/servicenetworking.networksAdmin",
    "roles/errorreporting.admin",
  ]

  # Compute admins for "roles/compute.admin"
  compute_admins = [
    "serviceAccount:terraform-sa@security-376019.iam.gserviceaccount.com",
    "serviceAccount:440726713913-compute@developer.gserviceaccount.com",
  ]

  container_devs = [
    "group:eng@enduesoftware.com",
    "serviceAccount:project-service-account@${module.prod_project.project_id}.iam.gserviceaccount.com",
    "serviceAccount:440726713913-compute@developer.gserviceaccount.com",
  ]
}
