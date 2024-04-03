variable "project_name" {
  type        = string
  description = "project Name"
}
variable "Env" {
  type = string
}
variable "region" {
  type        = string
  description = "region for infra"
}
variable "cidr-webapp" {
  description = "The CIDR range for the subnet"
}
variable "cidr-db" {
  description = "The CIDR range for the subnet"
}
variable "private-subnet-name" {
  description = "private Subnet name"
}
variable "public-subnet-name" {
  description = "public Subnet name"
}

variable "routing_mode" {
  description = "Routing Mode"
}

variable "auto_create_subnetworks" {
  type = bool
}

variable "delete_default_routes" {
  type = bool
}


variable "route_dest_range" {
  type        = string
  description = "destination IP for route"
}

variable "firewall-allow-name" {
  type        = string
  description = "Firewall Name For HTTP request"
}

variable "firewall-deny-name" {
  type        = string
  description = "Firewall Name To Deny SSH"
}

variable "firewall-allow-protocol" {
  type        = string
  description = "protocol for firewall"
  default     = "tcp"
}

variable "firewall-allow-port" {
  type        = list(string)
  description = "port list"
  default     = ["80", "8080"]

}

variable "firewall-allow-source" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "firewall-deny-protocol" {
  type        = string
  description = "protocol for firewall"
  default     = "tcp"
}

variable "firewall-deny-port" {
  type        = list(string)
  description = "port list"
  default     = ["22"]
}

variable "firewall-deny-source" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "target-tag" {
  type = list(string)
}
variable "web-route-next-hop-gateway" {
  type    = string
  default = "default-internet-gateway"
}

variable "instance-name" {
  type        = string
  description = "Instance name"
}
variable "machine_type" {
  type = string
}

variable "zone" {
  type = string

}
variable "image-family" {
  type = string
}

variable "disk-size" {
  type = string
}
variable "disk_type" {
  type = string
}

variable "network_tier" {
  type = string
}
variable "tags" {
  type = list(string)
}

variable "db_name" {
  type = string

}

variable "db_user" {
  type = string

}

variable "sql_instance_name" {
  type = string
}

variable "db_version" {
  type = string
}

variable "db_tier" {
  type = string
}

variable "db_aval_type" {
  type = string
}

variable "db_disk_type" {
  type = string
}

variable "db_size" {
  type = string
}

variable "global_addr_type" {
  type = string
}
variable "global_addr_purpose" {
  type = string
}
variable "global_addr_name" {
  type = string
}

variable "dns_zone_name" {
  type = string
}

variable "dns_record_type" {
  type = string
}

variable "dns_ttl" {
  type = number
}

variable "service_account_id" {
  type = string
}

variable "logging_role" {
  type = string
}
variable "monitoring_role" {
  type = string
}
variable "service_account_scopes" {
  type = list(string)
}

variable "MAILGUN_API_KEY" {
  type = string
}

variable "DOMAIN" {
  type = string
}
variable "PUB_SUB_TOPIC" {
  type = string
}
variable "ApplicationPort" {
  type        = string
  description = "Webserver port to create link from cloud function"
}

variable "cf2_sa_invoker" {
  type = string
}

variable "cf2_event_type" {
  type = string
}

variable "cf2_retry_policy" {
  type = string
}

variable "cf2_ingress_settings" {
  type = string
}

variable "cf2_all_traffic" {
  type = bool
}
variable "cf2_vpc_con_egress_settings" {
  type = string
}

variable "cf2_sc_max_instance" {
  type = number
}

variable "cf2_sc_min_instance" {
  type = number
}

variable "cf2_aval_memory" {
  type = string
}

variable "cf2_timeout_seconds" {
  type = number
}
variable "cf2_entry_point" {
  type = string
}
variable "cf2_runtime" {
  type = string
}
variable "cf2_name" {
  type = string
}
variable "cf2_func_description" {
  type = string
}
variable "vpc_connector_name" {
  type = string
}
variable "vpc_connector_ip_range" {
  type = string
}
variable "bucket_objet_name" {
  type = string
}

variable "bucket_objet_source_zip" {
  type        = string
  description = "Zip name , this must be in root directory"
}

variable "storage_bucket_location" {
  type = string
}

variable "storage_bucket_force_destroy" {
  type = bool
}

variable "subscription_name" {
  type = string
}

variable "sub_message_retention_duration" {
  type = string
}

variable "subscription_ack_deadline" {
  type = number
}
variable "sub_minimum_backoff" {
  type = string
}

variable "sub_maximum_backoff" {
  type = string
}

variable "pubsub_message_retention_duration" {
  type = string
}

variable "cf2_sa_sql_client_role" {
  type = string
}

variable "cf2_sa_sql_logWriter" {
  type = string
}

variable "cf2_sa_subscriber_role" {
  type = string
}
variable "cf2_service_account_name" {
  type = string
}

variable "cf2_service_account_id" {
  type = string
}
variable "instance_sa_publisher_role" {
  type = string
}
variable "pubsub_sa_token_creator_role" {
  type = string
}

variable "firewall-deny_all_http-protocol" {
  type = string
}

variable "firewall-deny_all_http-port" {
  type = list(string)
}

variable "instance_template_name" {
  type = string
}

variable "health_check_name" {
  type = string
}

variable "health_check_timeout_sec" {
  type = number
}

variable "health_check_chk_interval_sec" {
  type = number
}

variable "health_check_healthy_threshold" {
  type = number
}

variable "health_check_unhealthy_threshold" {
  type = number
}

variable "health_check_request_path" {
  type = string
}

variable "health_check_port" {
  type = string
}

variable "igm_name" {
  type = string
}

variable "igm_base_instance_name" {
  type = string
}

variable "igm_distribution_policy_zones" {
  type = list(string)
}

variable "igm_distribution_policy_target_shape" {
  type = string
}

variable "igm_np_name" {
  type = string
}

variable "igm_np_port" {
  type = number
}

variable "igm_healing_initial_delay_sec" {
  type = number
}

variable "igm_version_name" {
  type = string
}

variable "autoscaler_name" {
  type = string
}

variable "autoscaler_max_replicas" {
  type = number
}

variable "autoscaler_min_replicas" {
  type = number
}

variable "autoscaler_cooldown_period" {
  type = number
}
variable "autoscaler_cpu_utilization_target" {
  type = number
}

variable "ssl_name" {
  type = string
}

variable "lb_backend_name" {
  type = string
}

variable "lb_backend_scheme" {
  type = string
}
variable "lb_backend_locality_lb_policy" {
  type = string
}
variable "lb_backend_port_name" {
  type = string
}
variable "lb_backend_protocol" {
  type = string
}
variable "lb_backend_session_affinity" {
  type = string
}
variable "lb_backend_timeout_sec" {
  type = number

}
variable "lb_backend_balancing_mode" {
  type = string
}

variable "lb_backend_capacity_scaler" {
  type = number
}

variable "lb_backend_max_utilization" {
  type = number
}
variable "url_map_name" {
  type = string
}
variable "target_https_proxy_name" {
  type = string
}

variable "forwarding_rule_name" {
  type = string
}

variable "forwarding_rule_ip_protocol" {
  type = string
}
variable "forwarding_rule_load_balancing_scheme" {
  type = string

}
variable "forwarding_rule_port_range" {
  type = string
}

variable "firewall_deny_all_http_name" {
  type = string
}