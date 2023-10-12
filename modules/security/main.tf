module "sa_workload_identity" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  version = "~> 25.0"

  project_id          = var.project_id
  use_existing_k8s_sa = true
  annotate_k8s_sa     = false
  for_each            = var.ksa
  name                = each.value
  namespace           = each.key
  roles               = var.workload_identity_roles
}

resource "google_project_iam_binding" "default_sa_roles_binding" {
  for_each = toset(var.default_sa_roles)
  project  = var.project_id
  role     = each.value
  members  = var.default_sa
}

resource "google_project_iam_binding" "eng_roles_binding" {
  for_each = toset(var.eng_roles)
  project  = var.project_id
  role     = each.value
  members  = var.engs
}

resource "google_project_iam_binding" "admin_roles_binding_env" {
  for_each = toset(var.admin_roles)
  project  = var.project_id
  role     = each.value
  members  = var.admins
}

resource "google_project_iam_binding" "devops_roles_binding" {
  for_each = toset(var.devops_roles)
  project  = var.project_id
  role     = each.value
  members  = var.devops
}

# For security project
resource "google_project_iam_binding" "admin_roles_binding_security" {
  for_each = toset(var.admin_roles)
  project  = "security-376019"
  role     = each.value
  members  = var.admins
}

resource "google_project_iam_binding" "compute_sa_binding" {
  project = var.project_id
  role    = "roles/compute.admin"
  members = var.compute_admins
}

resource "google_project_iam_binding" "container_sa_binding" {
  project = var.project_id
  role    = "roles/container.developer"
  members = var.container_devs
}

resource "google_project_iam_binding" "terraform_role_binding" {
  for_each = toset([var.project_id])
  project  = each.value
  role     = "organizations/1096701462492/roles/terraformCustomRole"
  members = [
    "serviceAccount:terraform-sa@security-376019.iam.gserviceaccount.com",
  ]
}
