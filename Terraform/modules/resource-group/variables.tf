variable "project" {}
variable "location" {
  type = string
}
variable "environment" {
  type        = string
  description = "Environment name (dev, uat, prod)"
}