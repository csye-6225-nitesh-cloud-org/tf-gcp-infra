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

resource "google_service_account" "webapp_service_account" {
  account_id   = var.service_account_id
  display_name = "WebApp Service Account"
}
data "google_compute_image" "webapp_image" {
  family  = "${var.Env}-${var.image-family}"
  project = var.project_name
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
      image = data.google_compute_image.webapp_image.self_link

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
    db_user        = var.db_user
    db_password    = random_password.db_password.result
    db_host        = google_sql_database_instance.webapp_db.private_ip_address
    db_name        = var.db_name
    PUB_SUB_TOPIC  = var.PUB_SUB_TOPIC
    GCP_PROJECT_ID = var.project_name
    PORT_WEBAPP    = var.ApplicationPort

  })
  service_account {
    email  = google_service_account.webapp_service_account.email
    scopes = var.service_account_scopes
  }
  depends_on = [google_service_account.webapp_service_account]
}
resource "google_project_iam_binding" "logging_admin" {
  project = var.project_name
  role    = var.logging_role
  members = [
    "serviceAccount:${google_service_account.webapp_service_account.email}"
  ]
  depends_on = [google_service_account.webapp_service_account]
}

resource "google_project_iam_binding" "monitoring_writer" {
  project = var.project_name
  role    = var.monitoring_role
  members = [
    "serviceAccount:${google_service_account.webapp_service_account.email}"
  ]
  depends_on = [google_service_account.webapp_service_account]
}

resource "google_project_iam_binding" "instance_pubsub_publisher" {
  project = var.project_name
  role    = var.instance_sa_publisher_role
  members = [
    "serviceAccount:${google_service_account.webapp_service_account.email}"
  ]
  depends_on = [google_service_account.webapp_service_account]
}
data "google_dns_managed_zone" "dns_zone" {
  name = var.dns_zone_name
}
resource "google_dns_record_set" "A" {
  name         = data.google_dns_managed_zone.dns_zone.dns_name
  managed_zone = data.google_dns_managed_zone.dns_zone.name
  type         = var.dns_record_type
  ttl          = var.dns_ttl
  rrdatas = [
    google_compute_instance.webapp-instance.network_interface[0].access_config[0].nat_ip
  ]
}

resource "google_service_account" "cloud_function_sa" {
  account_id   = var.cf2_service_account_id
  display_name = var.cf2_service_account_name
}

resource "google_project_iam_binding" "monitoring_writer_Cf_sa" {
  project = var.project_name
  role    = var.monitoring_role
  members = [
    "serviceAccount:${google_service_account.cloud_function_sa.email}"
  ]
  depends_on = [google_service_account.cloud_function_sa]
}
resource "google_project_iam_binding" "pubsub_subscriber" {
  project = var.project_name
  role    = var.cf2_sa_subscriber_role
  members = [
    "serviceAccount:${google_service_account.cloud_function_sa.email}"
  ]
  depends_on = [google_service_account.cloud_function_sa]
}

resource "google_project_iam_binding" "log_writer" {
  project = var.project_name
  role    = var.cf2_sa_sql_logWriter
  members = [
    "serviceAccount:${google_service_account.cloud_function_sa.email}"
  ]
  depends_on = [google_service_account.cloud_function_sa]
}

resource "google_project_iam_binding" "cloudsql_client" {
  project = var.project_name
  role    = var.cf2_sa_sql_client_role
  members = [
    "serviceAccount:${google_service_account.cloud_function_sa.email}"
  ]
  depends_on = [google_service_account.cloud_function_sa]
}

resource "random_id" "bucket_prefix" {
  byte_length = 8
}
resource "google_pubsub_topic" "verify_email" {
  name                       = var.PUB_SUB_TOPIC
  message_retention_duration = var.pubsub_message_retention_duration
}

resource "google_pubsub_subscription" "verify_email_subscription" {
  name                       = var.subscription_name
  topic                      = google_pubsub_topic.verify_email.id
  message_retention_duration = var.sub_message_retention_duration
  ack_deadline_seconds       = var.subscription_ack_deadline
  retry_policy {
    minimum_backoff = var.sub_minimum_backoff
    maximum_backoff = var.sub_maximum_backoff
  }
  push_config {
    push_endpoint = google_cloudfunctions2_function.verify_email_function.url
  }
}
resource "google_storage_bucket" "function_source_bucket" {
  name          = "${random_id.bucket_prefix.hex}-cloud-functions"
  location      = var.storage_bucket_location
  force_destroy = var.storage_bucket_force_destroy
}

resource "google_storage_bucket_object" "function_source" {
  name   = var.bucket_objet_name
  bucket = google_storage_bucket.function_source_bucket.name
  source = "${path.module}/${var.bucket_objet_source_zip}"
}

resource "google_vpc_access_connector" "connector" {
  name          = var.vpc_connector_name
  ip_cidr_range = var.vpc_connector_ip_range
  network       = google_compute_network.vpc_network.self_link
  region        = var.region
}

data "google_project" "current_project" {
  project_id = var.project_name
}
resource "google_project_iam_binding" "pubsub_service_account_token_creator" {
  project = var.project_name
  role    = var.pubsub_sa_token_creator_role

  members = [
    "serviceAccount:service-${data.google_project.current_project.number}@gcp-sa-pubsub.iam.gserviceaccount.com",
  ]
}
resource "google_cloudfunctions2_function" "verify_email_function" {
  name        = var.cf2_name
  location    = var.region
  description = var.cf2_func_description
  build_config {
    runtime     = var.cf2_runtime
    entry_point = var.cf2_entry_point
    source {
      storage_source {
        bucket = google_storage_bucket.function_source_bucket.name
        object = google_storage_bucket_object.function_source.name
      }
    }
  }
  service_config {
    max_instance_count            = var.cf2_sc_max_instance
    min_instance_count            = var.cf2_sc_min_instance
    available_memory              = var.cf2_aval_memory
    timeout_seconds               = var.cf2_timeout_seconds
    vpc_connector                 = google_vpc_access_connector.connector.id
    vpc_connector_egress_settings = var.cf2_vpc_con_egress_settings
    environment_variables = {
      MAILGUN_API_KEY = var.MAILGUN_API_KEY
      DOMAIN          = var.DOMAIN
      PORT_WEBAPP     = var.ApplicationPort
      DB_HOST         = google_sql_database_instance.webapp_db.private_ip_address
      DB_USER         = var.db_user
      DB_PASSWORD     = random_password.db_password.result
      DB_NAME         = var.db_name
    }
    ingress_settings               = var.cf2_ingress_settings
    all_traffic_on_latest_revision = var.cf2_all_traffic
    service_account_email          = google_service_account.cloud_function_sa.email
  }
  event_trigger {
    event_type     = var.cf2_event_type
    pubsub_topic   = google_pubsub_topic.verify_email.id
    retry_policy   = var.cf2_retry_policy
    trigger_region = var.region
  }
}
resource "google_cloudfunctions2_function_iam_member" "invoker" {
  project        = google_cloudfunctions2_function.verify_email_function.project
  location       = google_cloudfunctions2_function.verify_email_function.location
  cloud_function = google_cloudfunctions2_function.verify_email_function.name
  role           = var.cf2_sa_invoker
  member         = "serviceAccount:${google_service_account.cloud_function_sa.email}"
}

