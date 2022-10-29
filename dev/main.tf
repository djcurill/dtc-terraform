module "nyc_taxi_data_lake" {
  source      = "../modules/lifecycle_bucket"
  bucket_name = "nyc-taxi-${var.env}-${var.project_id}"
  region      = var.region
  max_age     = 30 // days
}

resource "google_service_account" "airflow" {
  account_id   = "airflow-${var.env}"
  display_name = "airflow"
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
