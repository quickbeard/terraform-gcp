locals {
  records = [{
    name = "app"
    type = "A"
    ttl  = 300
    records = [
      "104.197.26.118" #public IP of ingress nginx in prod
    ]
    }, {
    name = "prod"
    type = "A"
    ttl  = 300
    records = [
      "104.197.26.118" #public IP of ingress nginx in prod
    ]
  }]
}
module "dns" {
  source  = "terraform-google-modules/cloud-dns/google"
  version = "~> 4.0"

  project_id                         = module.prod_project.project_id
  type                               = "public"
  name                               = "prod-onendue-com"
  domain                             = "onendue.com."
  private_visibility_config_networks = ["${module.vpc.network_self_link}"]

  recordsets = local.records
}
