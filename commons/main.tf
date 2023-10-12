module "github_repo" {
  source = "../modules/github-repo"

  github_repo_name        = "webapp"
  github_repo_description = "Endue Web App"
}