# Configure the Google Cloud provider
provider "google" {
  # Use the credentials file at the default location
  credentials = file("account.json")
  project     = "my-gcp-project"
  region      = "us-central1"
}

# Create a Kubernetes cluster
resource "google_container_cluster" "my-cluster" {
  name     = "my-cluster"
  location = "us-central1-a"
  initial_node_count = 3
}

# Deploy the containerized app to the cluster
resource "kubernetes_deployment" "my-app" {
  metadata {
    name = "my-app"
  }

  spec {
    # Use the Google Container Registry to pull the image
    container {
      image = "gcr.io/my-gcp-project/my-app:v1"
    }

    # Expose the app on port 8080
    container {
      name  = "my-app"
      port {
        container_port = 8080
      }
    }
  }
}

# Expose the deployment as a load balancer service
resource "kubernetes_service" "my-app-lb" {
  metadata {
    name = "my-app-lb"
  }

  spec {
    type        = "LoadBalancer"
    selector {
      app = "my-app"
    }

    # Expose the app on port 80
    port {
      port        = 80
      target_port = 8080
    }
  }
}
