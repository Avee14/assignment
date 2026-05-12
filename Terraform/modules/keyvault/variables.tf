variable "project" {}
variable "environment" {}
variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
variable "tenant_id" {
  description = "Azure AD tenant ID"
  type        = string
}
variable "aks_kubelet_object_id" {
  type = string
}
variable "db_admin_username" {}
variable "db_admin_password" {}
variable "postgres_fqdn" {
  type = string
}
variable "key_vault_id" {
  type = string
}