provider "google" {
  credentials = file("key.json") 
  project     = "aswini-447207"                  
  region      = "us-central1"                          
}

# VPC Network
resource "google_compute_network" "gke_vpc" {
  name                    = "gke-vpc"
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "gke_subnet" {
  name          = "gke-subnet"
  network       = google_compute_network.gke_vpc.id
  ip_cidr_range = "10.10.0.0/16"
  region        = "us-central1"
}

# GKE Cluster
resource "google_container_cluster" "gke_cluster" {
  name     = "my-gke-cluster"
  location = "us-central1"

  network    = google_compute_network.gke_vpc.id
  subnetwork = google_compute_subnetwork.gke_subnet.id

  remove_default_node_pool = true
  initial_node_count       = 1

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  ip_allocation_policy {}

  lifecycle {
    ignore_changes = [initial_node_count]
  }
}

# GKE Node Pool
resource "google_container_node_pool" "gke_nodes" {
  name       = "gke-node-pool"
  location   = google_container_cluster.gke_cluster.location
  cluster    = google_container_cluster.gke_cluster.name
  node_count = 2

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 50
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

# Output the GKE Cluster Name
output "gke_cluster_name" {
  value = google_container_cluster.gke_cluster.name
}

# Output the GKE Cluster Endpoint
output "gke_cluster_endpoint" {
  value = google_container_cluster.gke_cluster.endpoint
}
