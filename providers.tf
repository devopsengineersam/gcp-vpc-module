terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.34.0"
    }
  }
  backend "gcs" {
    bucket = "dspm-dig-state-bucket"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = "dspm-dig"
}
