resource "google_compute_network" "vpc" {
  name                    = "cloud-composer-network-${var.env}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "cloud_composer_subnet" {
  name          = "cloud-composer-subnet-${var.env}"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.vpc.id
}

resource "google_compute_router" "router" {
  project = var.project_id
  name    = "dtc-router-${var.env}"
  network = google_compute_network.vpc.id
  region  = var.region
}

resource "google_compute_router_nat" "nat" {
  name                               = "dtc-router-nat-${var.env}"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
