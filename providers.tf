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

    aptible = {
      source = "aptible/aptible"
      version = "~> 0.1"
    }
  }
}

provider "github" {
  token = var.github_token
  owner = var.github_org
}

provider "google" {
  project = var.gcp_project
}