# Create a cluster
resource "google_container_cluster" "my_cluster" {
  name = var.gke_cluster_name
  location = var.gke_zone

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count = 1
}

# Create a node pool
resource "google_container_node_pool" "my_node_pool" {
  name = var.gke_node_pool_name
  location = var.gke_zone
  cluster = google_container_cluster.my_cluster.name
  node_count = 2

  node_config {
    preemptible = true
    machine_type = var.gke_machine_type
  }
}
