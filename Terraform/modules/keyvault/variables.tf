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