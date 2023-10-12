module "cert_manager" {
  source = "../../modules/cert-manager"

  project_id = module.staging_project.project_id
}
