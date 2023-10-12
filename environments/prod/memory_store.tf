module "memorystore-redis" {
  source  = "terraform-google-modules/memorystore/google"
  version = "~> 7.1.0"

  project            = module.prod_project.project_id
  name               = "webapp-cache"
  region             = var.region
  memory_size_gb     = 1
  authorized_network = module.vpc.network_self_link
}
