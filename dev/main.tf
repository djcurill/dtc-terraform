module "lifecycle_bucket" {
  source      = "../modules/lifecycle_bucket"
  bucket_name = "nyc-taxi-${var.env}-${var.project_id}"
  region      = var.region
  max_age     = 30 // days
}