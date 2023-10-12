# For Terraform Cloud, remote backends, and providers configurations
terraform {
  # Terraform Cloud
  cloud {
    organization = "Endue"
    workspaces {
      name = "terraform-monorepo"
    }
  }

  # Providers
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }

    datadog = {
      source  = "DataDog/DataDog"
      version = "~> 3.25"
    }
  }
}

provider "github" {
  token = var.github_token
  owner = var.github_org
}

provider "google" {

}

provider "datadog" {

}