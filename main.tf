resource "google_service_account" "default" {
  account_id = "service-account-id"
  display_name = "Service Account"
}

# Create a cluster
resource "google_container_cluster" "my_cluster" {
  name = var.cluster
  location = var.region_east

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count = 1
}

# Create a node pool
resource "google_container_node_pool" "my_node_pool" {
  name = var.node_pool
  location = var.region_east
  cluster = google_container_cluster.my_cluster.name
  node_count = 1

  node_config {
    preemptible = true
    machine_type = var.machine_type

    /*
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    */
  }
}

# Deployments with helm
resource "helm_release" "example" {
  name       = "k8s-chart"
  chart      = "k8s-yaml-chart"

  /*
  set {
    name  = "image.repository"
    value = "my-image-repository"
  }

  set {
    name  = "image.tag"
    value = "latest"
  }
  */
}

/*
# Define the container image for the app
resource "google_container_image" "my_image" {
  name = "gcr.io/minh-sandbox/web-app-container"
}

# Deploy an app
resource "google_container_deployment" "my_deployment" {
  name = "demo-web-app"
  cluster = google_container_cluster.my_cluster.name
  image {
    name = google_container_image.my_image.name
    # tag = "latest"
  }
}
*/


/*
resource "kubernetes_deployment" "k8s_deployment" {
  metadata {
    name = "my-deployment"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "demo-web-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "demo-web-app"
        }
      }

      spec {
        container {
          image = "gcr.io/minh-sandbox/web-app-container"
          name  = "demo-web-app"
        }
      }
    }
  }
}
*/
