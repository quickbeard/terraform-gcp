module "datadog" {
  source = "../../modules/datadog"

  project_id = module.staging_project.project_id
}