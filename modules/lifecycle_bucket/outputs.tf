output "bucket_name" {
  value       = google_storage_bucket.gcp_bucket.name
  description = "Name of gcp bucket"
}