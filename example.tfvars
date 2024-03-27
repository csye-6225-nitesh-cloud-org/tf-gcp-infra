Env                        = "environment_name"
project_name               = "your_project_name"
region                     = "region_name"
cidr-webapp                = "ip_address/cidr"
cidr-db                    = "ip_address/cidr"
private-subnet-name        = "subnet_name"
public-subnet-name         = "subnet_name"
routing_mode               = "prefered_routing_mode"
auto_create_subnetworks    = true / flase
delete_default_routes      = true / flase
route_dest_range           = "x.x.x.x/x"
firewall-allow-name        = "firewall_name"
firewall-deny-name         = "firewall_name"
firewall-allow-protocol    = "protocol_name"
firewall-allow-port        = ["port", "port"]
firewall-allow-source      = ["x.x.x.x/x"]
firewall-deny-protocol     = "protocol_name"
firewall-deny-port         = ["port"]
firewall-deny-source       = ["x.x.x.x/x"]
target-tag                 = ["list of tags"]
web-route-next-hop-gateway = "next_hop_gateway"
instance-name              = "instance_name"
machine_type               = "machine_type"
zone                       = "zone_name"
image-family               = "custom_image_family_name"
disk_type                  = "disk_type"
disk-size                  = size_in_numbers
network_tier               = "network_tier"
tags                       = ["list of tags"]
db_name                    = "database_name"
db_user                    = "database_username"
sql_instance_name          = "db_sql_instance_name"
db_version                 = "db_version_name"
db_tier                    = "db_tier_name"
db_aval_type               = "db_availability_type"
db_disk_type               = "db_disk_type"
db_size                    = size_in_numbers
global_addr_purpose        = "purpose_of_global_address"
global_addr_name           = "global_address_name"
global_addr_type           = "global_address_typr"
dns_zone_name              = "your_dns_zone_name"
dns_record_type            = "record_type_Like_A"
dns_ttl                    = ttl_value
service_account_id         = "account_name"
logging_role               = "roles/logging.logWriter"
monitoring_role            = "roles/monitoring.metricWriter"
service_account_scopes     = ["list_of_scopes"]
MAILGUN_API_KEY            = "API KEY"
DOMAIN                     = "YOUR DOMAIN"
PUB_SUB_TOPIC              = "PUB/SUB TOPIC"
ApplicationPort            = ApplicationPortNumber 