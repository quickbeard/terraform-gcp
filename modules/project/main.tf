module "project_factory" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.1"

  name            = var.project_name
  org_id          = var.org_id
  billing_account = "01204B-B96898-528122"
}

module "project_services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 14.1"

  for_each      = toset(var.project_list)
  project_id    = each.value
  activate_apis = var.api_list
}