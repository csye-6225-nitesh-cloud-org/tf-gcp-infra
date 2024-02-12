output "webapp_subnet_cidr" {
  value = google_compute_subnetwork.subnet1.ip_cidr_range
}