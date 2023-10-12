locals {
  org_names = [
    "endue-prod",
    "chiarthritis-prod"
  ]
}

module "bucket" {
  source = "../../modules/cloud-storage"

  project_id    = module.prod_project.project_id
  region        = var.region
  storage_class = "STANDARD"
  storage_age   = "30"
  delete_age    = "45"

  set_admin_roles = true
  admins          = ["serviceAccount:webapp-sa@${module.prod_project.project_id}.iam.gserviceaccount.com"]

  for_each = toset(local.org_names)
  org_name = each.value
  bucket_admins = {
    "endue-${each.value}-bucket" = "serviceAccount:webapp-sa@${module.prod_project.project_id}.iam.gserviceaccount.com"
  }


}

