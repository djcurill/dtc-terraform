data "google_project" "project" {
  project_id = var.project_id
}

resource "google_project_service" "composer_api" {
  project            = var.project_id
  service            = "composer.googleapis.com"
  disable_on_destroy = false
}

resource "google_service_account" "cloud_composer_service_account" {
  account_id   = "composer-service-account-${var.env}"
  display_name = "Cloud Composer Service Account"
}

resource "google_project_iam_member" "cloud_composer_iam" {
  for_each = toset([
    "roles/storage.objectAdmin",
    "roles/bigquery.dataEditor",
    "roles/iam.serviceAccountUser",
    "roles/composer.worker",
    "roles/composer.admin"
  ])
  role    = each.key
  member  = "serviceAccount:${google_service_account.cloud_composer_service_account.email}"
  project = var.project_id
}

resource "google_service_account_iam_member" "cloud_composer_iam_binding" {
  service_account_id = google_service_account.cloud_composer_service_account.name
  role               = "roles/composer.ServiceAgentV2Ext"
  member             = "serviceAccount:service-${data.google_project.project.number}@cloudcomposer-accounts.iam.gserviceaccount.com"
}

resource "google_compute_subnetwork" "cloud_composer_subnet" {
  name          = "cloud-composer-subnet-${var.env}"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = var.vpc.id
}

resource "google_composer_environment" "cloud_composer" {
  name    = "dtc-cloud-composer-${var.env}"
  region  = var.region
  project = var.project_id
  config {
    environment_size = "ENVIRONMENT_SIZE_SMALL"

    software_config {
      image_version = "composer-2.0.30-airflow-2.3.3"
      airflow_config_overrides = {
        core-dags_are_paused_at_creation = "True"
      }
      env_variables = {
        GCS_PROJECT_ID      = var.project_id
        GCP_GCS_BUCKET      = var.gcp_bucket
        AIRFLOW_STAGING_DIR = "/home/airflow/gcs/data/yellow_trip_data"
      }
    }

    node_config {
      network         = var.vpc.id
      subnetwork      = google_compute_subnetwork.cloud_composer_subnet.id
      service_account = google_service_account.cloud_composer_service_account.name
    }

    workloads_config {
      scheduler {
        cpu        = 1
        memory_gb  = 4
        storage_gb = 4
        count      = 1
      }
      web_server {
        cpu        = 1
        memory_gb  = 4
        storage_gb = 4
      }
      worker {
        cpu        = 4
        memory_gb  = 8
        storage_gb = 8
        min_count  = 1
        max_count  = 3
      }
    }
  }
}

