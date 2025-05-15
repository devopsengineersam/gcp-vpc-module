# service-account.tf
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
}

resource "google_service_account" "dspm_deployer" {
  account_id   = "dspm-deployer"
  display_name = "DSPM Deployment Service Account"
}

resource "google_project_iam_member" "network_admin" {
  project = var.project_id
  role    = "roles/compute.networkAdmin"
  member  = "serviceAccount:${google_service_account.dspm_deployer.email}"
}

resource "google_project_iam_member" "service_networking" {
  project = var.project_id
  role    = "roles/servicenetworking.serviceAgent"
  member  = "serviceAccount:${google_service_account.dspm_deployer.email}"
}

resource "google_project_iam_member" "service_account_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.dspm_deployer.email}"
}

resource "google_service_account_key" "dspm_key" {
  service_account_id = google_service_account.dspm_deployer.name
}

output "service_account_email" {
  value = google_service_account.dspm_deployer.email
}

output "key_file" {
  value = google_service_account_key.dspm_key.private_key
  sensitive = true
}

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}