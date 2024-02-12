resource "google_compute_network" "vpc_network" {
  project                 = var.project_name
  name                    = "vpc-network"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "subnet1" {
  name          = "subnet1"
  region        = var.region
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = "172.168.0.0/24"
}