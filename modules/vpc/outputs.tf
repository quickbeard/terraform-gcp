output "network_name" {
  value = module.vpc.network_name
}

output "subnetwork" {
  value = module.vpc.subnets["${var.region}/services-subnet"].name
}

output "db_ip_range" {
  value = google_compute_global_address.services_ranges["db-ip-range"].name
}

output "network_self_link" {
  value = module.vpc.network_self_link
}

output "secondary_pods_range_name" {
  value = var.secondary_pods_range_name
}

output "secondary_services_range_name" {
  value = var.secondary_services_range_name
}