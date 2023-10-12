module "prod_project" {
  source = "../../modules/project"

  org_id       = var.org_id
  project_name = "endue-prod"
  project_list = [module.prod_project.project_name]

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

  project_id                    = module.prod_project.project_id
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

module "cloudsql_postgresql" {
  source = "../../modules/cloudsql-postgres"

  project_id = module.prod_project.project_id
  # See https://cloud.google.com/sql/pricing#cloud-sql-pricing for postgres tier list
  db_tier                        = "db-g1-small"
  deletion_protection            = true
  db_ip_range                    = module.vpc.db_ip_range
  private_network                = module.vpc.network_self_link
  point_in_time_recovery_enabled = true
  retained_backups               = 14

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

module "secrets" {
  source = "../../modules/secrets"

  project_id = module.prod_project.project_id
  for_each = {
    nextauth-secret     = var.nextauth_secret_prod
    fhirserver-password = var.fhirserver_password_prod
    auth0-client-secret = var.auth0_client_secret_prod
    dd-api-key          = var.dd_api_key
    dd-app-key          = var.dd_app_key
  }
  secret_id   = each.key
  secret_data = each.value
}
