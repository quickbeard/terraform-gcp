# This module runs all terraform files in 'common' folder, including:
# Create a new GitHub repo
# Create a new GCP project
module "common" {
    source = "./commons"

    # GitHub repo
    github_repo_name = "source_monorepo"
    github_repo_description = "Source codes monorepo"
}



# This module runs all terraform files in 'environments' folder, including:
# Create a GKE cluster with a node pool
# Create a new Aptible app and endpoint
module "environments" {
    source = "./environments"

    # GKE cluster
    gke_cluster_name = "endue-staging"
    gke_zone = "us-central1-c"
    gke_node_pool_name = "staging-node-pool"
    gke_machine_type = "e2-medium"

    # Aptible app
    aptible_env_name = "endue-prod"
    aptible_app_name = "website"
    app_docker_image = "gcr.io/minh-sandbox/main-website"
}
