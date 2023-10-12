# Instructions

Monorepo for Terraform codes.

Run `terraform login` in your local machine first.

## Environments directory

### GKE cluster

- Create a cluster and a node pool in Google Kubernetes Engine (GKE).

- For local: run `gcloud auth application-default login` in your local machine.

- For Terraform Cloud: create an environment variable named GOOGLE_CREDENTIALS (set it as sensitive) and put the output of your JSON file (generated from `gcloud auth application-default login` command). This is an one-time step and most likely it has been set up.

- For more details, see https://support.hashicorp.com/hc/en-us/articles/4406586874387-How-to-set-up-Google-Cloud-GCP-credentials-in-Terraform-Cloud 

## Commons directory

### GCP Service Account

- Create a Service Account in GCP.

### GitHub repo

- Create a repo in GitHub. You might have to run `gh auth login` first.

- You might need to create a GitHub personal access token first.
