module "aptible_app" {
  source = "../../../modules/aptible-app"
  aptible_env_name = var.aptible_env_name
  aptible_app_name = var.aptible_app_name
  app_docker_image = var.app_docker_image
}