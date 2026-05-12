# ============================================================
# variables.tf — Input variables
# ============================================================

# ─── Project ─────────────────────────────────────────────────
variable "project" {
  description = "Project name used as a prefix for all resources"
  type        = string
  default     = "spring-app"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,18}[a-z0-9]$", var.project))
    error_message = "Project name must be 4-20 lowercase letters, numbers, or hyphens, starting with a letter."
  }
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "location" {
  description = "Azure region to deploy resources into"
  type        = string
  default     = "eastus"
}

# ─── Networking ──────────────────────────────────────────────
variable "vnet_address_space" {
  description = "CIDR block for the virtual network"
  type        = string
  default     = "10.0.0.0/8"
}

variable "aks_subnet_cidr" {
  description = "CIDR block for AKS node subnet"
  type        = string
  default     = "10.1.0.0/16"
}

variable "private_endpoints_subnet_cidr" {
  description = "CIDR block for private endpoints subnet"
  type        = string
  default     = "10.2.0.0/24"
}

variable "postgres_subnet_cidr" {
  description = "CIDR block for PostgreSQL delegated subnet"
  type        = string
  default     = "10.3.0.0/24"
}

# ─── AKS ─────────────────────────────────────────────────────
variable "kubernetes_version" {
  description = "Kubernetes version for AKS cluster"
  type        = string
  default     = "1.29"
}

variable "system_node_count" {
  description = "Initial node count for system node pool"
  type        = number
  default     = 2
}

variable "system_node_vm_size" {
  description = "VM size for system node pool"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "system_node_min_count" {
  description = "Minimum node count for system pool autoscaler"
  type        = number
  default     = 1
}

variable "system_node_max_count" {
  description = "Maximum node count for system pool autoscaler"
  type        = number
  default     = 3
}

variable "app_node_vm_size" {
  description = "VM size for app node pool"
  type        = string
  default     = "Standard_D4s_v3"
}

variable "app_node_min_count" {
  description = "Minimum node count for app pool autoscaler"
  type        = number
  default     = 1
}

variable "app_node_max_count" {
  description = "Maximum node count for app pool autoscaler"
  type        = number
  default     = 5
}


# ─── PostgreSQL ───────────────────────────────────────────────
variable "postgres_admin_username" {
  description = "Administrator username for PostgreSQL Flexible Server"
  type        = string
  default     = "psqladmin"

  validation {
    condition     = !contains(["admin", "administrator", "root", "postgres"], lower(var.postgres_admin_username))
    error_message = "Admin username cannot be a reserved word (admin, administrator, root, postgres)."
  }
}

variable "postgres_database_name" {
  description = "Name of the application database"
  type        = string
  default     = "springdb"
}

variable "postgres_sku" {
  description = "SKU for PostgreSQL Flexible Server (compute tier and size)"
  type        = string
  default     = "B_Standard_B1ms" # burstable, good for dev/test
}

variable "postgres_storage_mb" {
  description = "Storage size in MB for PostgreSQL"
  type        = number
  default     = 32768 # 32 GB

  validation {
    condition     = var.postgres_storage_mb >= 32768
    error_message = "PostgreSQL storage must be at least 32768 MB (32 GB)."
  }
}

variable "postgres_backup_retention_days" {
  description = "Number of days to retain PostgreSQL backups"
  type        = number
  default     = 7

  validation {
    condition     = var.postgres_backup_retention_days >= 7 && var.postgres_backup_retention_days <= 35
    error_message = "Backup retention must be between 7 and 35 days."
  }
}

# ─── Monitoring ──────────────────────────────────────────────
variable "log_retention_days" {
  description = "Number of days to retain logs in Log Analytics Workspace"
  type        = number
  default     = 30
}

variable "alert_email" {
  description = "Email address to receive monitoring alerts"
  type        = string
  default     = "ops@example.com"
}
