module "gke_cluster" {
    source = "./gke-cluster"
    gke_cluster_name = var.gke_cluster_name
    gke_zone = var.gke_zone
    gke_node_pool_name = var.gke_node_pool_name
    gke_machine_type = var.gke_machine_type
}

module "aptible_app" {
    source = "./aptible-app"
    aptible_env_name = var.aptible_env_name
    aptible_app_name = var.aptible_app_name
    app_docker_image = var.app_docker_image
}