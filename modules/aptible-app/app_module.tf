terraform {
  required_providers {
    aptible = {
      source = "aptible/aptible"
      version = "~> 0.1"
    }
  }
}

# Get the Aptible environment ID
data "aptible_environment" "prod-env" {
  handle = var.aptible_env_name
}

# Deploy an app
resource "aptible_app" "web-app" {
  env_id = data.aptible_environment.prod-env.env_id
  handle = var.aptible_app_name

  config = {
    "APTIBLE_DOCKER_IMAGE" = var.app_docker_image
  }

  service {
    process_type = "cmd"
    container_count = 1
    container_memory_limit = 512
  }
}

/*
# Add an endpoint
resource "aptible_endpoint" "main-endpoint" {
  env_id = data.aptible_environment.prod-env.env_id
  resource_id = aptible_app.web-app.app_id
  resource_type = "app"
  process_type = "cmd"
  default_domain = true
  # managed = true
  # domain = "www.enduesoftware.com"
}
*/