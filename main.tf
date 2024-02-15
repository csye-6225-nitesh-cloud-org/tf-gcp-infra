resource "google_compute_network" "vpc_network" {
  project                         = var.project_name
  name                            = "vpc-network-${var.Env}"
  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
  delete_default_routes_on_create = true
}

resource "google_compute_subnetwork" "webapp-subnet" {
  name          = "webapp-subnet-${var.Env}"
  region        = var.region
  network       = google_compute_network.vpc_network.self_link
  ip_cidr_range = var.cidr-webapp
}
resource "google_compute_subnetwork" "db-subnet" {
  name          = "db-subnet-${var.Env}"
  region        = var.region
  network       = google_compute_network.vpc_network.self_link
  ip_cidr_range = var.cidr-db
}

resource "google_compute_route" "webapp-route" {
  name             = "webapp-route-${var.Env}"
  dest_range       = "0.0.0.0/0"
  network          = google_compute_network.vpc_network.self_link
  next_hop_gateway = "default-internet-gateway"
}