variable "org_id" {
  type = string
}

variable "region" {
  type        = string
  description = "Default region to create resources in"
}

variable "zone" {
  type = string
}

# Secrets
variable "nextauth_secret_staging" {
  type      = string
  sensitive = true
}

variable "fhirserver_password_staging" {
  type      = string
  sensitive = true
}

variable "auth0_client_secret_staging" {
  type      = string
  sensitive = true
}

variable "dd_api_key" {
  type      = string
  sensitive = true
}

variable "dd_app_key" {
  type      = string
  sensitive = true
}