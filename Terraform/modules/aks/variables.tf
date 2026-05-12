variable "project" {}
variable "environment" {}
variable "kubernetes_version" {}
variable "system_node_count" {}
variable "system_node_vm_size" {}
variable "system_node_min_count" {}
variable "system_node_max_count" {}
variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}
variable "subnet_id" {
  type = string
}
variable "workspace_id" {
  type = string
}
variable "acr_id" {
  type = string
}