module "webapp_buckets" {
  source  = "terraform-google-modules/cloud-storage/google"
  version = "~> 4.0"

  project_id = var.project_id
  location   = var.region

  storage_class = var.storage_class

  names = ["endue-${var.org_name}-bucket"]
  folders = {
    "endue-${var.org_name}-bucket" = ["documents", "uploads"]
  }

  versioning = {
    "endue-${var.org_name}-bucket" = true
  }

  set_admin_roles = var.set_admin_roles
  admins          = var.admins
  bucket_admins   = var.bucket_admins

  cors = [{
    origin          = ["*"]
    method          = ["GET", "HEAD", "PUT", "POST", "OPTIONS"]
    response_header = ["*"]
    max_age_seconds = 3600
  }]

  lifecycle_rules = [{
    action = {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
    condition = {
      age                   = "${var.storage_age}"
      matches_prefix        = "documents/*"
      matches_storage_class = "STANDARD"
    }
    }, {
    action = {
      type = "Delete"
    }
    condition = {
      age            = "${var.delete_age}"
      matches_prefix = "documents/*"
    }
  }]
}
