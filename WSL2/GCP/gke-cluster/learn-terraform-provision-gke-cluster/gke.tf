variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "gke_num_nodes" {
  default     = 2
  description = "number of gke nodes"
}

variable "node-locations" {
  type = list
  default = [ "us-central1-a", "us-central1-b", "us-central1-c" ]
  description = "zone locations for the nodes to create"
}

# GKE cluster
resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-gke"
  location = var.region
  node_locations = var.node-locations

  # Below statement holds true only when, "remove_default_node_pool = true" -> here I am using default node pool by setting it "false".

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = false
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.project_id
    }

    machine_type = "e2-medium" # n1-standard-1 (1 cpu node, so with kodekloud limit can scale upto 4 nodes by adding new zones in "node_locations")
    disk_size_gb = 10
    disk_type = "pd-standard"
    tags         = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

# Commented below block to use default node pool, due to quotas restriction for Kode Kloud playground usage, 
# Which causes quotas overlapping, when default node pool is created and deleted immediately and new node pool is created as per below block.

# Separately Managed Node Pool
# resource "google_container_node_pool" "primary_nodes" {
#   name       = "${google_container_cluster.primary.name}-node-pool"
#   location   = var.region
#   cluster    = google_container_cluster.primary.name
#   node_count = var.gke_num_nodes

#   node_config {
#     oauth_scopes = [
#       "https://www.googleapis.com/auth/logging.write",
#       "https://www.googleapis.com/auth/monitoring",
#     ]

#     labels = {
#       env = var.project_id
#     }

#     # preemptible  = true
#     machine_type = "n1-standard-1" # n1-standard-1 (1 cpu node, so with kodekloud limit can scale upto 5 nodes)
#     disk_size_gb = 10
#     disk_type = "pd-standard"
#     tags         = ["gke-node", "${var.project_id}-gke"]
#     metadata = {
#       disable-legacy-endpoints = "true"
#     }
#   }
# }


# # Kubernetes provider
# # The Terraform Kubernetes Provider configuration below is used as a learning reference only. 
# # It references the variables and resources provisioned in this file. 
# # We recommend you put this in another file -- so you can have a more modular configuration.
# # https://learn.hashicorp.com/terraform/kubernetes/provision-gke-cluster#optional-configure-terraform-kubernetes-provider
# # To learn how to schedule deployments and services using the provider, go here: https://learn.hashicorp.com/tutorials/terraform/kubernetes-provider.

# provider "kubernetes" {
#   load_config_file = "false"

#   host     = google_container_cluster.primary.endpoint
#   username = var.gke_username
#   password = var.gke_password

#   client_certificate     = google_container_cluster.primary.master_auth.0.client_certificate
#   client_key             = google_container_cluster.primary.master_auth.0.client_key
#   cluster_ca_certificate = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
# }

