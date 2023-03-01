provider "google" {
  credentials = "${file("6ad5a4a03b.json")}"
  project = "customer-vpc"
  region  = "us-central1"
}

# # https://www.terraform.io/language/settings/backends/gcs
# terraform {
#   backend "gcs" {
#     bucket = "cs-tf-test"
#     prefix = "terraform/state"
#   }
#   required_providers {
#     google = {
#       source  = "hashicorp/google"
#       version = "~> 4.0"
#     }
#   }
# }


