variable "project_name" {
  type        = string
  description = "project Name"
  default     = "csye6225-webapp"
}
variable "Env" {
  type        = string
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