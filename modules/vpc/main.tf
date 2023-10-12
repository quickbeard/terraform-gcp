module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 6.0"

  project_id   = var.project_id
  network_name = var.network_name
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name               = "services-subnet"
      subnet_ip                 = var.services_subnet_ip
      subnet_region             = var.region
      description               = "This subnet is for services, including those run on GKE"
      subnet_flow_logs          = true
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.5
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
    },
  ]

  secondary_ranges = {
    services-subnet = [
      {
        range_name    = var.secondary_pods_range_name
        ip_cidr_range = var.secondary_pods_ip
      },
      {
        range_name    = var.secondary_services_range_name
        ip_cidr_range = var.secondary_services_ip
      },
    ]
  }

  routes = [
    {
      name              = "egress-internet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    },
  ]
}

resource "google_compute_global_address" "services_ranges" {
  for_each = {
    "db-ip-range" : [var.db_ip, var.db_prefix_length]
    "ids-ip-range" : [var.ids_ip, var.ids_prefix_length]
  }
  project       = var.project_id
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  ip_version    = "IPV4"
  network       = module.vpc.network_self_link
  name          = each.key
  address       = each.value[0]
  prefix_length = each.value[1]
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = module.vpc.network_self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.services_ranges["db-ip-range"].name]
  depends_on              = [google_compute_global_address.services_ranges["db-ip-range"]]
}