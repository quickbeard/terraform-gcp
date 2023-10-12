module "staging_project" {
  source = "../../modules/project"

  org_id       = var.org_id
  project_name = "endue-staging-263b"
  project_list = [module.staging_project.project_name, "security-376019"]

  api_list = [
    "artifactregistry.googleapis.com",
    "bigquery.googleapis.com",
    "bigtableadmin.googleapis.com",
    "cloudasset.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudtasks.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "containeranalysis.googleapis.com",
    "containerregistry.googleapis.com",
    "containerscanning.googleapis.com",
    "dns.googleapis.com",
    "documentai.googleapis.com",
    "firestore.googleapis.com",
    "iam.googleapis.com",
    "ids.googleapis.com",
    "logging.googleapis.com",
    "memcache.googleapis.com",
    "monitoring.googleapis.com",
    "pubsub.googleapis.com",
    "redis.googleapis.com",
    "secretmanager.googleapis.com",
    "servicenetworking.googleapis.com",
    "serviceusage.googleapis.com",
    "spanner.googleapis.com",
    "sqladmin.googleapis.com",
    "storage-api.googleapis.com",
  ]
}

module "vpc" {
  source = "../../modules/vpc"

  project_id                    = module.staging_project.project_id
  network_name                  = "vpc"
  region                        = var.region
  zone                          = var.zone
  services_subnet_ip            = "10.10.10.0/24"
  secondary_pods_range_name     = "us-central1-01-gke-01-pods"
  secondary_pods_ip             = "10.1.0.0/16"
  secondary_services_range_name = "us-central1-01-gke-01-services"
  secondary_services_ip         = "10.2.0.0/20"
  db_ip                         = "10.10.20.0"
  db_prefix_length              = 24
  ids_ip                        = "10.10.30.0"
  ids_prefix_length             = 24
}

module "gke" {
  source = "../../modules/gke"

  project_id                    = module.staging_project.project_id
  region                        = var.region
  gke_cluster_name              = "endue-staging"
  gke_node_pool_name            = "primary-node-pool"
  gke_node_pool_count           = 2
  gcp_machine_type              = "n1-standard-4"
  network                       = module.vpc.network_name
  subnetwork                    = module.vpc.subnetwork
  secondary_pods_range_name     = module.vpc.secondary_pods_range_name
  secondary_services_range_name = module.vpc.secondary_services_range_name
}

module "monitoring" {
  source = "../../modules/monitoring-logging"

  project_id = module.staging_project.project_id
  # TODO: figure out how to add multiple emails
  email                       = "thi@enduesoftware.com"
  utilization_threshold_value = 80
  count_threshold_value       = 10000
}

module "cloudsql_postgresql" {
  source = "../../modules/cloudsql-postgres"

  project_id      = module.staging_project.project_id
  db_tier         = "db-f1-micro"
  db_ip_range     = module.vpc.db_ip_range
  private_network = module.vpc.network_self_link

  for_each = {
    fhir-postgres   = ["fhirserver-db-password", "fhirserver-db-url", "5432", "postgres"],
    webapp-postgres = ["webapp-db-password", "webapp-db-url", "5432", "postgres"],
  }
  db_instance_name = each.key
  db_password      = each.value[0]
  db_url           = each.value[1]
  db_port          = each.value[2]
  db_name          = each.value[3]
}

module "webapp_buckets" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "~> 4.0"

  project_id = module.staging_project.project_id
  location   = var.region

  iam_members = [{
    role   = "roles/storage.objectAdmin"
    member = "serviceAccount:webapp-sa@${module.staging_project.project_id}.iam.gserviceaccount.com"
  }]

  cors = [{
    origin          = ["*"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE", "OPTIONS"]
    response_header = ["*"]
    max_age_seconds = 3600
  }]


  for_each = {
    "staging-us-clientdocuments" : [
      {
        retention_period = 5000000 # in seconds
        is_locked        = false
      },
      false,
    ]
    "clientuploads-staging" : [
      null,
      true,
    ]
  }
  name             = each.key
  retention_policy = each.value[0]
  versioning       = each.value[1]
}

resource "google_document_ai_processor" "document_ai_processors" {
  project  = module.staging_project.project_id
  location = "us"

  for_each = {
    client-docs-ocr : "OCR_PROCESSOR"
    client-docs-parser : "FORM_PARSER_PROCESSOR"
  }
  display_name = each.key
  type         = each.value
}

module "memorystore-redis" {
  source  = "terraform-google-modules/memorystore/google"
  version = "~> 7.1.0"

  project            = module.staging_project.project_id
  name               = "webapp-cache"
  region             = var.region
  memory_size_gb     = 1
  authorized_network = module.vpc.network_self_link
}

module "secrets" {
  source = "../../modules/secrets"

  project_id = module.staging_project.project_id
  for_each = {
    nextauth-secret     = var.nextauth_secret_staging
    fhirserver-password = var.fhirserver_password_staging
    auth0-client-secret = var.auth0_client_secret_staging
    dd-api-key          = var.dd_api_key
    dd-app-key          = var.dd_app_key
  }
  secret_id   = each.key
  secret_data = each.value
}

module "accounts_roles" {
  source = "../../modules/accounts-roles"

  org_id     = var.org_id
  project_id = module.staging_project.project_id

  # Workload Identity
  ksa = {
    external-secrets = "secret-store-sa"
    fhir-server      = "fhir-sa"
    webapp           = "webapp-sa"
  }
  workload_identity_roles = [
    "roles/cloudsql.editor",
    "roles/secretmanager.secretAccessor",
  ]

  # webapp SA roles
  webapp_sa = [
    "serviceAccount:webapp-sa@${module.staging_project.project_id}.iam.gserviceaccount.com",
  ]
  webapp_sa_roles = [
    "roles/documentai.apiUser",
  ]

  # Default SA roles
  default_sa = [
    "serviceAccount:project-service-account@${module.staging_project.project_id}.iam.gserviceaccount.com",
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
    "roles/compute.networkAdmin",
    "roles/container.admin",
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
    "serviceAccount:731850567079-compute@developer.gserviceaccount.com",
  ]

  container_devs = [
    "group:eng@enduesoftware.com",
    "serviceAccount:project-service-account@${module.staging_project.project_id}.iam.gserviceaccount.com",
    "serviceAccount:731850567079-compute@developer.gserviceaccount.com",
  ]
}
