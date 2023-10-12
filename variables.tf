variable "github_org" {
  type    = string
  default = "enduesoftware"
}

# Secrets
variable "github_token" {
  type    = string
  default = ""
}

variable "nextauth_secret_staging" {
  type    = string
  default = ""
}

variable "fhirserver_password_staging" {
  type    = string
  default = ""
}

variable "auth0_client_secret_staging" {
  type    = string
  default = ""
}

variable "dd_api_key" {
  type      = string
  sensitive = true
}

variable "dd_app_key" {
  type      = string
  sensitive = true
}

variable "nextauth_secret_prod" {
  type    = string
  default = ""
}

variable "fhirserver_password_prod" {
  type    = string
  default = ""
}

variable "auth0_client_secret_prod" {
  type    = string
  default = ""
}
