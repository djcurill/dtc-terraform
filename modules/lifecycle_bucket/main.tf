resource "google_storage_bucket" "gcp_bucket" {
  name                        = var.bucket_name
  location                    = var.region
  storage_class               = var.storage_class
  force_destroy               = true
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = var.max_age // days
    }
    action {
      type = "Delete"
    }
  }
}