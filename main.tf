module "commons" {
  source = "./commons"

  github_repo_name        = "monorepo"
  github_repo_description = "Endue Software Monorepo"
  org_id                  = "1096701462492"
}

module "environments" {
  source = "./environments"

  org_id = "1096701462492"
  region = "us-central1"
  zone   = "us-central1-a"

  # Secrets (Terraform Cloud variables)
  nextauth_secret_staging     = var.nextauth_secret_staging
  fhirserver_password_staging = var.fhirserver_password_staging
  auth0_client_secret_staging = var.auth0_client_secret_staging

  nextauth_secret_prod     = var.nextauth_secret_prod
  fhirserver_password_prod = var.fhirserver_password_prod
  auth0_client_secret_prod = var.auth0_client_secret_prod

  # DataDog API key, this will be use in every env, so we don't need to have suffix
  dd_api_key = var.dd_api_key
  dd_app_key = var.dd_app_key
}
