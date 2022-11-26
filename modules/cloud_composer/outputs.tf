output "composer_bucket" {
    type = string
    value = google_composer_environment.cloud_composer.config.0.dag_gcs_prefix
}