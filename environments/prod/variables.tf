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
variable "nextauth_secret_prod" {
  type = string
}

variable "fhirserver_password_prod" {
  type = string
}

variable "auth0_client_secret_prod" {
  type = string
}

variable "dd_api_key" {
  type      = string
  sensitive = true
}

variable "dd_app_key" {
  type      = string
  sensitive = true
}