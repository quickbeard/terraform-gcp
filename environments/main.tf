module "staging" {
  source = "./staging"

  org_id = var.org_id
  region = var.region
  zone   = var.zone

  # Staging secrets
  nextauth_secret_staging     = var.nextauth_secret_staging
  fhirserver_password_staging = var.fhirserver_password_staging
  auth0_client_secret_staging = var.auth0_client_secret_staging
  dd_api_key                  = var.dd_api_key
  dd_app_key                  = var.dd_app_key
}

module "prod" {
  source = "./prod"

  org_id = var.org_id
  region = var.region
  zone   = var.zone

  # Prod secrets
  nextauth_secret_prod     = var.nextauth_secret_prod
  fhirserver_password_prod = var.fhirserver_password_prod
  auth0_client_secret_prod = var.auth0_client_secret_prod
  dd_api_key               = var.dd_api_key
  dd_app_key               = var.dd_app_key
}