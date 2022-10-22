terraform {
  backend "gcs" {
    bucket = "dev-dtc-terraform-state"
    prefix = ""
  }

  required_providers {
    google = {
      source = "hashicorp/google"
    }

  }
}