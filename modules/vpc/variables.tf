variable "project_id" {
  type = string
}

variable "network_name" {
  type = string
}


variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "services_subnet_ip" {
  type = string
}

variable "secondary_pods_range_name" {
  type = string
}

variable "secondary_pods_ip" {
  type = string
}

variable "secondary_services_range_name" {
  type = string
}

variable "secondary_services_ip" {
  type = string
}

variable "db_ip" {
  type = string
}

variable "db_prefix_length" {
  type = number
}

variable "ids_ip" {
  type = string
}

variable "ids_prefix_length" {
  type = number
}