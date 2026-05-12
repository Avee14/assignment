variable "project" {}
variable "environment" {}
variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
variable "postgres_admin_username" {}
variable "postgres_subnet_id" {
  type = string
}
variable "private_dns_zone_id" {
  type = string
}
variable "common_tags" {
  default = {}
}
variable "postgres_storage_mb" {}
variable "postgres_sku" {}
variable "postgres_database_name" {}
variable "key_vault_id" {
  type = string
}