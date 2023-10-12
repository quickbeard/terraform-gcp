locals {
  # Terraform permissions
  tf_permissions = [
    "billing.resourceAssociations.create",
    "billing.accounts.get",
    "billing.accounts.getIamPolicy",
    "billing.accounts.list",
    "billing.accounts.redeemPromotion",
    "billing.credits.list",
    "essentialcontacts.contacts.get",
    "essentialcontacts.contacts.list",
    "orgpolicy.constraints.list",
    "orgpolicy.policies.list",
    "orgpolicy.policy.get",
    "iam.serviceAccounts.create",
    "iam.serviceAccounts.delete",
    "iam.serviceAccounts.disable",
    "iam.serviceAccounts.enable",
    "iam.serviceAccounts.get",
    "iam.serviceAccounts.getIamPolicy",
    "iam.serviceAccounts.list",
    "iam.serviceAccounts.update",
    "resourcemanager.organizations.get",
    "resourcemanager.projects.create",
    "resourcemanager.projects.get",
    "resourcemanager.projects.list",
    "resourcemanager.folders.get",
    "resourcemanager.folders.list",
    "resourcemanager.projects.createBillingAssignment",
    "storage.buckets.create",
    "storage.buckets.delete",
    "storage.buckets.get",
    "storage.buckets.getIamPolicy",
    "storage.buckets.list",
    "storage.buckets.listEffectiveTags",
    "storage.buckets.listTagBindings",
    "storage.buckets.update",
    "storage.multipartUploads.abort",
    "storage.multipartUploads.create",
    "storage.multipartUploads.listParts",
    "storage.objects.create",
    "storage.objects.delete",
    "storage.objects.get",
    "storage.objects.getIamPolicy",
    "storage.objects.list",
    "storage.objects.update",
  ]
}

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

resource "google_project_iam_binding" "webapp_sa_roles_binding" {
  for_each = toset(var.webapp_sa_roles)
  project  = var.project_id
  role     = each.value
  members  = var.webapp_sa
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

resource "google_project_iam_binding" "devops_roles_binding" {
  for_each = toset(var.devops_roles)
  project  = var.project_id
  role     = each.value
  members  = var.devops
}

# For staging project
resource "google_project_iam_binding" "admin_roles_binding_staging" {
  for_each = toset(var.admin_roles)
  project  = var.project_id
  role     = each.value
  members  = var.admins
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

resource "google_organization_iam_custom_role" "terraform_custom_role" {
  org_id      = var.org_id
  role_id     = "terraformCustomRole"
  title       = "Terraform Custom Role"
  description = "Organization custom role for Terraform"
  permissions = local.tf_permissions
}

resource "google_project_iam_binding" "terraform_role_binding" {
  for_each = toset([var.project_id, "security-376019"])
  project  = each.value
  role     = google_organization_iam_custom_role.terraform_custom_role.id
  members = [
    "serviceAccount:terraform-sa@security-376019.iam.gserviceaccount.com",
  ]
}
