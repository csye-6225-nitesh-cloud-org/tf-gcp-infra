variable "project_name" {
  type        = string
  description = "project Name"
  default     = "csye6225-webapp"
}
variable "region" {
  type        = string
  description = "region for infra"
  default     = "us-east1"
}
variable "subnet_cidr" {
  description = "The CIDR range for the subnet"
  default     = "172.168.0.0/24"
}