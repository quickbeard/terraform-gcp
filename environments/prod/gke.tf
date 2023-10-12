locals {
  project_id                    = module.prod_project.project_id
  region                        = var.region
  zones                         = ["us-central1-a", "us-central1-b", "us-central1-c", "us-central1-f"]
  gke_cluster_name              = "endue-prod"
  network                       = module.vpc.network_name
  subnetwork                    = module.vpc.subnetwork
  secondary_pods_range_name     = module.vpc.secondary_pods_range_name
  secondary_services_range_name = module.vpc.secondary_services_range_name

  #Specific node pool configuration
  gke_primary_node_pool_name  = "primary-node-pool"
  gke_primary_node_pool_count = 0
  gke_primary_machine_type    = "n1-standard-4"
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "~> 25.0"

  project_id                 = local.project_id
  name                       = local.gke_cluster_name
  region                     = local.region
  zones                      = local.zones
  network                    = local.network
  subnetwork                 = local.subnetwork
  ip_range_pods              = local.secondary_pods_range_name
  ip_range_services          = local.secondary_services_range_name
  http_load_balancing        = false
  network_policy             = false
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = false
  release_channel            = "STABLE"
  remove_default_node_pool   = true

  node_pools = [
    {
      name               = local.gke_primary_node_pool_name
      machine_type       = local.gke_primary_machine_type
      node_locations     = "us-central1-b,us-central1-c"
      max_count          = 20
      min_count          = local.gke_primary_node_pool_count
      service_account    = "project-service-account@${local.project_id}.iam.gserviceaccount.com"
      initial_node_count = local.gke_primary_node_pool_count
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/sqlservice.admin",
    ]
  }

  node_pools_labels = {
    all = {}

    primary-node-pool = {
      env  = "production"
      team = "Endue"
      pool = "primary"
    }
  }

  node_pools_taints = {
    all = []
  }

  node_pools_tags = {
    all = []

    primary-node-pool = [
      "primary-node-pool", "production"
    ]
  }
}
