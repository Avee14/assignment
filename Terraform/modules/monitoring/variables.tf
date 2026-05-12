variable "project" {}
variable "environment" {}
variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
variable "log_retention_days" {
  default = 30
}
variable "common_tags" {
  default = {}
}
variable "workspace_name" {}
variable "appinsights_name" {}