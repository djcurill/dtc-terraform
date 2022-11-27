module "nyc_taxi_data_lake" {
  source      = "../modules/lifecycle_bucket"
  bucket_name = "nyc-taxi-${var.env}-${var.project_id}"
  region      = var.region
  max_age     = 30 // days
}

module "cloud_composer" {
  source         = "../modules/cloud_composer"
  project_id     = var.project_id
  project_number = var.project_number
  region         = var.region
  env            = var.env
  vpc            = google_compute_network.vpc
  gcp_bucket     = module.nyc_taxi_data_lake.bucket_name
}

locals {
  composer_bucket = module.cloud_composer.composer_bucket
}

resource "google_compute_network" "vpc" {
  name                    = "cloud-composer-network-${var.env}"
  auto_create_subnetworks = false
}

resource "google_project_service" "enable_compute_api" {
  project = var.project_id
  service = "compute.googleapis.com"
}

resource "google_service_account" "airflow" {
  account_id   = "airflow-${var.env}"
  display_name = "airflow"
}

resource "google_service_account" "airflow_cicd" {
  account_id   = "airflow-cicd-${var.env}"
  display_name = "CI / CD Service Account for Airflow Deployments"
}

resource "google_service_account_iam_binding" "airflow_cicd" {
  service_account_id = google_service_account.airflow_cicd.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "principalSet://iam.googleapis.com/projects/523776208646/locations/global/workloadIdentityPools/github-pool/attribute.repository/djcurill/dtc-airflow",
    "principalSet://iam.googleapis.com/projects/523776208646/locations/global/workloadIdentityPools/github-pool/*"
  ]
}


resource "google_storage_bucket_iam_member" "airflow_cicd" {
  bucket = var.cloud_composer_bucket
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.airflow_cicd.email}"
}

resource "google_bigquery_dataset" "big_query" {
  dataset_id    = var.BQ_DATASET
  friendly_name = "BigQuery: NYC Taxi Data"
  project       = var.project_id
  location      = var.region
}

resource "google_project_iam_member" "airflow" {
  for_each = toset([
    "roles/storage.objectAdmin",
    "roles/bigquery.dataEditor"
  ])
  role    = each.key
  member  = "serviceAccount:${google_service_account.airflow.email}"
  project = var.project_id
}
