terraform {
  backend "gcs" {
    bucket = "dtc-prod-terraform-state"
    prefix = ""
  }

  required_providers {
    google = {
      source = "hashicorp/google"
    }

  }
}