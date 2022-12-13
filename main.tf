/*
resource "google_service_account" "default" {
  account_id = "service-account-id"
  display_name = "Service Account"
}
*/

resource "google_container_cluster" "my_cluster" {
  name = var.cluster
  location = var.region_east

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count = 1
}

resource "google_container_node_pool" "my_node_pool" {
  name = var.node_pool
  location = var.region_east
  cluster = google_container_cluster.my_cluster.name
  node_count = 1

  node_config {
    preemptible = true
    machine_type = var.machine_type

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "kubernetes_deployment" "k8s_deployment" {
  metadata {
    name = "demo-web-app"
  }

  spec {
    # Use the Google Container Registry to pull the image
    container {
      image = "gcr.io/minh-sandbox/web-app-container"
    }

    # Expose the app on port 8080
    container {
      name  = "demo-web-app"
      port {
        container_port = 80
      }
    }
  }
}
