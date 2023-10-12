locals {
  records = [{
    name = "demo"
    type = "A"
    ttl  = 300
    records = [
      "34.122.68.97" #public IP of ingress nginx in staging
    ]
    }, {
    name = "app"
    type = "A"
    ttl  = 300
    records = [
      "34.122.68.97" #public IP of ingress nginx in staging
    ]
  }]
}
module "dns" {
  source  = "terraform-google-modules/cloud-dns/google"
  version = "~> 4.0"

  project_id                         = module.staging_project.project_id
  type                               = "public"
  name                               = "staging-onendue-com"
  domain                             = "onendue-staging.com."
  private_visibility_config_networks = ["${module.vpc.network_self_link}"]

  recordsets = local.records
}
