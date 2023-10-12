variable "project_id" {
  description = "which project we want to create bucket in"
  type        = string
}

variable "region" {
  description = "location where we want to locate our bucket"
  type        = string
}

variable "org_name" {
  description = "Customer name that we will use to create a bucket"
  type        = string
}

variable "storage_age" {
  description = "we will set the storage class after this"
  type        = string
}

variable "delete_age" {
  description = "we will delete object after this"
  type        = string
}

variable "storage_class" {
  description = "storage class that we will use for our bucket"
  type        = string
}

variable "admins" {
  description = "who will be the admin storage for all bucket"
  type        = list(string)
  default     = []
}

variable "bucket_admins" {
  description = "who will be the object storage admin of this bucket"
  type        = map(string)
  default     = {}
}

variable "set_admin_roles" {
  description = "whether we should set admin or not"
  type        = bool
  default     = false
}
