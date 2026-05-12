variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

# ─── Random suffix to ensure globally unique names ───────────
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

variable "project" {
  description = "Project name used as a prefix for all resources"
  type        = string
  default     = "spring-app"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,18}[a-z0-9]$", var.project))
    error_message = "Project name must be 4-20 lowercase letters, numbers, or hyphens, starting with a letter."
  }
}

# ─── Container Registry ───────────────────────────────────────
variable "acr_sku" {
  description = "SKU for Azure Container Registry (Basic, Standard, Premium)"
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.acr_sku)
    error_message = "ACR SKU must be Basic, Standard, or Premium."
  }
}

variable "acr_georeplications" {
  description = "List of regions for ACR geo-replication (Premium SKU only)"
  type        = list(string)
  default     = []
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}