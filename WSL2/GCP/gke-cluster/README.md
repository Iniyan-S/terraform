# Launches Kubernetes cluster Lab in Google Cloud for Learning purposes

This repo is a companion repo to the [Provision a GKE Cluster learn guide](https://learn.hashicorp.com/terraform/kubernetes/provision-gke-cluster), containing Terraform configuration files to provision an GKE cluster on GCP.

This sample repo also creates a VPC and subnet for the GKE cluster. This is not
required but highly recommended to keep your GKE cluster isolated.

This is forked and updated to use default node pool, as it conflicted with quotas set for Kode Kloud playground policy.

## Perform Below Steps

- Initialize Kode Kloud playground and login to Google Cloud with the credentials shown in the playground initialize page
- on WSL2, configure gcloud SDK

```
gcloud init
```
- Authorize gcloud SDK to access GCP and add your account to the Application Default Credentials (ADC). This will allow Terraform to access these credentials to provision resources on GCloud.

```
gcloud auth application-default login
```

- Update the values in your "terraform.tfvars" file with your project_id
```
# terraform.tfvars
project_id = "REPLACE_ME"
region     = "us-central1"
```

- To find find the project your gcloud is configured to with below command
```
gcloud config get-value project
```

- Initialize Terraform  workspace (if needed) & provisiion GKE cluster
```
terraform init
teraform apply
```

- Configure kubectl
```
gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) --region $(terraform output -raw region)
```
