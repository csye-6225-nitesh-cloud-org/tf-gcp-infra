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

variable "target-tag"{
  type    = list(string)
}
 variable "web-route-next-hop-gateway" {
  type = string
  default = "default-internet-gateway"
 }