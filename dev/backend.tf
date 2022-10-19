terraform {
  backend "gcs" {
    bucket  = "dtc-dev-terraform-state"
    prefix = ""
  }

  required_providers {
    google = {
      source = "hashicorp/google"
    }

  }
}