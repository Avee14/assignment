variable "project" {}
variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}
variable "environment" {}
variable "postgres_subnet_cidr" {}
variable "vnet_address_space" {}
variable "aks_subnet_cidr" {}