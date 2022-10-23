module "nyc_taxi_data_lake" {
  source      = "../modules/lifecycle_bucket"
  bucket_name = "nyc-taxi-${var.env}-${var.project_id}"
  region      = var.region
  max_age     = 30 // days
}

resource "google_service_account" "airflow" {
  account_id   = "airflow-${var.env}"
  display_name = "Airflow"
}

resource "google_storage_bucket_iam_member" "airflow" {
  bucket = module.nyc_taxi_data_lake.bucket_name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.airflow.email}"
}


