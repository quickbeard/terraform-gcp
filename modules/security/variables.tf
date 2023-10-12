variable "org_id" {
  type = string
}

variable "project_id" {
  type = string
}

variable "ksa" {
  type = map(string)
}

variable "workload_identity_roles" {
  type = list(string)
}

variable "default_sa_roles" {
  type = list(string)
}

variable "default_sa" {
  type = list(string)
}

variable "eng_roles" {
  type = list(string)
}

variable "engs" {
  type = list(string)
}

variable "devops_roles" {
  type = list(string)
}

variable "devops" {
  type = list(string)
}

variable "admin_roles" {
  type = list(string)
}

variable "admins" {
  type = list(string)
}

variable "compute_admins" {
  type = list(string)
}

variable "container_devs" {
  type = list(string)
}

