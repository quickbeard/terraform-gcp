module "datadog" {
  source = "../../modules/datadog"

  project_id = module.prod_project.project_id
}