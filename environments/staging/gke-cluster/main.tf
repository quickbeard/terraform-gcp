module "gke_cluster" {
  source = "../../../modules/gke-cluster"
  gke_cluster_name = var.gke_cluster_name
  gke_zone = var.gke_zone
  gke_node_pool_name = var.gke_node_pool_name
  gke_machine_type = var.gke_machine_type
}