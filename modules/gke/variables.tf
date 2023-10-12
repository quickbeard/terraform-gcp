variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

# GKE cluster
variable "gke_cluster_name" {
  type = string
}

variable "gke_node_pool_name" {
  type = string
}

variable "gcp_machine_type" {
  type = string
}

variable "gke_node_pool_count" {
  type = number
}

# Networks
variable "network" {
  type = string
}

variable "subnetwork" {
  type = string
}

variable "secondary_pods_range_name" {
  type = string
}

variable "secondary_services_range_name" {
  type = string
}