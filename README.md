# Instructions

Monorepo for Terraform codes.

Run `terraform login` in your local machine first.



## Commons directory

### GitHub repo

- Create a repo in GitHub.

- You might need to create a GitHub personal access token first.




## Environments directory

### GKE cluster (environments)

- Create a cluster and a node pool in Google Kubernetes Engine (GKE).

- For local: run `gcloud auth application-default login` in your local machine.

- For Terraform Cloud: create an environment variable named GOOGLE_CREDENTIALS (set it as sensitive) and put the output of your JSON file (generated from `gcloud auth application-default login` command). This is an one-time step and most likely it has been set up.

- For more details, see https://support.hashicorp.com/hc/en-us/articles/4406586874387-How-to-set-up-Google-Cloud-GCP-credentials-in-Terraform-Cloud 

### Aptible app (environments)

- Deploy an app and an endpoint in Aptible.

- For local: run `aptible login` in your local machine.

- For Terraform Cloud: create two environment variables `APTIBLE_USERNAME` and `APTIBLE_PASSWORD` (set them as sensitive). This is an one-time step and most likely it has been set up.

- For more details, see https://registry.terraform.io/providers/aptible/aptible/latest/docs.
