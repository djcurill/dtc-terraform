resource "google_storage_bucket" "data-lake-bucket" {
  name     = "dtc-${var.env}-demo-bucket"
  location = var.region
}