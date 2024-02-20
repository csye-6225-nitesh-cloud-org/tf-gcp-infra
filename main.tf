resource "google_compute_network" "vpc_network" {
  project                         = var.project_name
  name                            = "vpc-network-${var.Env}"
  auto_create_subnetworks         = var.auto_create_subnetworks
  routing_mode                    = var.routing_mode
  delete_default_routes_on_create = var.delete_default_routes
}

resource "google_compute_subnetwork" "webapp-subnet" {
  name          = var.public-subnet-name
  region        = var.region
  network       = google_compute_network.vpc_network.self_link
  ip_cidr_range = var.cidr-webapp
}
resource "google_compute_subnetwork" "db-subnet" {
  name          = var.private-subnet-name
  region        = var.region
  network       = google_compute_network.vpc_network.self_link
  ip_cidr_range = var.cidr-db
}

resource "google_compute_route" "webapp-route" {
  name             = "${var.public-subnet-name}-route-${var.Env}"
  dest_range       = var.route_dest_range
  network          = google_compute_network.vpc_network.self_link
  next_hop_gateway = var.web-route-next-hop-gateway
}

resource "google_compute_firewall" "allow-http" {
  project = var.project_name
  name    = var.firewall-allow-name
  network = google_compute_network.vpc_network.self_link
  allow {
    protocol = var.firewall-allow-protocol
    ports    = var.firewall-allow-port
  }
  source_ranges = var.firewall-allow-source
  target_tags   = var.target-tag
}

resource "google_compute_firewall" "deny-ssh" {
  project = var.project_name
  name    = var.firewall-deny-name
  network = google_compute_network.vpc_network.self_link
  deny {
    protocol = var.firewall-deny-protocol
    ports    = var.firewall-deny-port
  }
  source_ranges = var.firewall-deny-source
  target_tags   = var.target-tag
}
