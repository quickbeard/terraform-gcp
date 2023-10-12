resource "github_repository" "github_repo" {
  name        = var.github_repo_name
  description = var.github_repo_description
  visibility  = var.github_repo_visibility # default: private
}
