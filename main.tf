provider "google" {
  credentials = "${file("26ad5a4a03b.json")}"
  project = "customer-vpc"
  region  = "us-central1"
}

resource "google_container_cluster" "my_cluster" {
  name               = "my-gke-cluster"
  location           = "us-central1-c"
  initial_node_count = 1

  node_config {
    machine_type = "n1-standard-1"
    disk_size_gb = 100
  }


  network = "default"
}

provider "kubernetes" {
  config_path    = "/Users/pr/.kube/config"
  #config_context = "minikube"
}

resource "kubernetes_namespace" "services" {
  metadata {
    name = "services"
  }
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}