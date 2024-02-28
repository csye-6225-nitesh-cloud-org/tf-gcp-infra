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
resource "google_compute_global_address" "private_ip_address" {
  name          = var.global_addr_name
  purpose       = var.global_addr_purpose
  address_type  = var.global_addr_type
  prefix_length = 16
  network       = google_compute_network.vpc_network.self_link
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc_network.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
} #Issue with destroying VPC NETWORK PEERING https://github.com/hashicorp/terraform-provider-google/issues/16275 Set deletion_policy=ABANDON & clean manually

resource "random_id" "db_name_suffix" {
  byte_length = 4
}
resource "google_sql_database_instance" "webapp_db" {
  name                = "${var.sql_instance_name}-${random_id.db_name_suffix.hex}"
  database_version    = var.db_version
  deletion_protection = false
  settings {
    tier              = var.db_tier
    availability_type = var.db_aval_type
    disk_type         = var.db_disk_type
    disk_size         = var.db_size
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.vpc_network.self_link
    }
  }
  depends_on = [
    google_service_networking_connection.private_vpc_connection
  ]
}

resource "google_sql_database" "database_name" {
  name     = var.db_name
  instance = google_sql_database_instance.webapp_db.name
}

resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#%&*()-_=+<>:?"
}

resource "google_sql_user" "webapp_user" {
  name     = var.db_user
  instance = google_sql_database_instance.webapp_db.name
  password = random_password.db_password.result
}


resource "google_compute_instance" "webapp-instance" {
  name         = var.instance-name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = var.tags
  boot_disk {
    auto_delete = true
    initialize_params {
      size  = var.disk-size
      type  = var.disk_type
      image = "${var.Env}-${var.image-family}"

    }
  }
  network_interface {
    network    = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.webapp-subnet.self_link
    access_config {
      network_tier = var.network_tier
    }
  }
  metadata_startup_script = templatefile("startup-script.sh.tpl", {
    db_user     = var.db_user
    db_password = random_password.db_password.result
    db_host     = google_sql_database_instance.webapp_db.private_ip_address
    db_name     = var.db_name
  })
}   