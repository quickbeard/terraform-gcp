terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

# Create a GitHub repo
resource "github_repository" "my_repo" {
  name = var.github_repo_name
  description = var.github_repo_description
  visibility = var.github_repo_visibility  # default: private
}
