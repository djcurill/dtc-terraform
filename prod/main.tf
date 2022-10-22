resource "google_storage_bucket" "data-lake-bucket" {
  name     = "dtc-${var.env}-test123-demo-bucket"
  location = var.region
}