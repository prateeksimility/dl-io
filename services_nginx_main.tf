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

resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "nginx-deployment"
    namespace = kubernetes_namespace.services.metadata.0.name
  }

  spec {
    selector {
      match_labels = {
        app = "nginx"
      }
    }

    replicas = 1

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name      = "nginx-service"
    namespace = kubernetes_namespace.services.metadata.0.name
  }

  spec {
    selector = {
      app = kubernetes_deployment.nginx.spec.0.template.0.metadata.0.labels.app
    }

    port {
      name       = "http"
      protocol   = "TCP"
      port       = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}
