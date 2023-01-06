module "github_repo" {
    source = "../../modules/github-repo"
    github_repo_name = var.github_repo_name
    github_repo_description = var.github_repo_description
}
