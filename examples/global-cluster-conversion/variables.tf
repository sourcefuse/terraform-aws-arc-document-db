# =============================================================================
# CORE PROJECT VARIABLES
# =============================================================================

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "docdb-global-conversion"
}

variable "environment" {
  description = "Environment name for primary cluster"
  type        = string
  default     = "prod"
}

# =============================================================================
# REGION CONFIGURATION
# =============================================================================

variable "primary_region" {
  description = "AWS region where the existing cluster is located"
  type        = string
  default     = "us-east-1"
}

variable "secondary_region" {
  description = "AWS region for the disaster recovery cluster"
  type        = string
  default     = "us-west-2"
}

# =============================================================================
# GLOBAL CLUSTER CONFIGURATION
# =============================================================================

variable "global_cluster_identifier" {
  description = "Identifier for the global cluster"
  type        = string
  default     = null

  validation {
    condition     = var.global_cluster_identifier == null || can(regex("^[a-z][a-z0-9-]*[a-z0-9]$", var.global_cluster_identifier))
    error_message = "Global cluster identifier must start with a letter, contain only lowercase letters, numbers, and hyphens, and end with a letter or number."
  }
}

# =============================================================================
# PRIMARY CLUSTER CONFIGURATION (EXISTING CLUSTER TO CONVERT)
# =============================================================================

variable "primary_cluster_identifier" {
  description = "Identifier of the existing cluster to convert to global"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]*[a-z0-9]$", var.primary_cluster_identifier))
    error_message = "Cluster identifier must start with a letter, contain only lowercase letters, numbers, and hyphens, and end with a letter or number."
  }
}

variable "primary_instance_count" {
  description = "Number of instances in the primary cluster"
  type        = number
  default     = 2

  validation {
    condition     = var.primary_instance_count >= 1 && var.primary_instance_count <= 15
    error_message = "Instance count must be between 1 and 15."
  }
}

variable "primary_instance_class" {
  description = "Instance class for primary cluster instances"
  type        = string
  default     = "db.t3.medium"
}

variable "primary_vpc_name" {
  description = "Name tag of the VPC in the primary region"
  type        = string
  default     = "default"
}

# =============================================================================
# SECONDARY CLUSTER CONFIGURATION (NEW DR CLUSTER)
# =============================================================================

variable "secondary_cluster_identifier" {
  description = "Identifier for the secondary (DR) cluster"
  type        = string
  default     = null

  validation {
    condition     = var.secondary_cluster_identifier == null || can(regex("^[a-z][a-z0-9-]*[a-z0-9]$", var.secondary_cluster_identifier))
    error_message = "Cluster identifier must start with a letter, contain only lowercase letters, numbers, and hyphens, and end with a letter or number."
  }
}

variable "secondary_instance_count" {
  description = "Number of instances in the secondary cluster"
  type        = number
  default     = 1

  validation {
    condition     = var.secondary_instance_count >= 1 && var.secondary_instance_count <= 15
    error_message = "Instance count must be between 1 and 15."
  }
}

variable "secondary_instance_class" {
  description = "Instance class for secondary cluster instances"
  type        = string
  default     = "db.t3.medium"
}

variable "secondary_vpc_name" {
  description = "Name tag of the VPC in the secondary region"
  type        = string
  default     = "default"
}

# =============================================================================
# ENGINE CONFIGURATION
# =============================================================================

variable "engine_version" {
  description = "DocumentDB engine version (must match existing cluster)"
  type        = string
  default     = "4.0.0"

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.engine_version))
    error_message = "Engine version must be in the format X.Y.Z (e.g., 4.0.0)."
  }
}

# =============================================================================
# AUTHENTICATION CONFIGURATION
# =============================================================================

variable "master_username" {
  description = "Master username for the existing cluster (must match current cluster)"
  type        = string
  default     = "docdbadmin"

  validation {
    condition     = length(var.master_username) >= 1 && length(var.master_username) <= 63
    error_message = "Master username must be between 1 and 63 characters."
  }
}

variable "master_password" {
  description = "Master password for the existing cluster (must match current cluster)"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.master_password) >= 8 && length(var.master_password) <= 100
    error_message = "Master password must be between 8 and 100 characters."
  }
}

# =============================================================================
# SECURITY CONFIGURATION
# =============================================================================

variable "storage_encrypted" {
  description = "Whether to encrypt the DocumentDB cluster"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Whether to enable deletion protection"
  type        = bool
  default     = true
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access DocumentDB"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

# =============================================================================
# BACKUP CONFIGURATION
# =============================================================================

variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = 7

  validation {
    condition     = var.backup_retention_period >= 1 && var.backup_retention_period <= 35
    error_message = "Backup retention period must be between 1 and 35 days."
  }
}

variable "preferred_backup_window" {
  description = "The daily time range during which automated backups are created"
  type        = string
  default     = "07:00-09:00"
}

variable "preferred_maintenance_window" {
  description = "The weekly time range during which system maintenance can occur (primary)"
  type        = string
  default     = "sun:05:00-sun:06:00"
}

variable "secondary_preferred_backup_window" {
  description = "The daily time range during which automated backups are created (secondary)"
  type        = string
  default     = "10:00-12:00" # Different from primary to avoid conflicts
}

variable "secondary_preferred_maintenance_window" {
  description = "The weekly time range during which system maintenance can occur (secondary)"
  type        = string
  default     = "sun:08:00-sun:09:00" # Different from primary to avoid conflicts
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before deletion"
  type        = bool
  default     = false
}

# =============================================================================
# MONITORING CONFIGURATION
# =============================================================================

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to CloudWatch"
  type        = list(string)
  default     = ["audit", "profiler"]

  validation {
    condition = alltrue([
      for log_type in var.enabled_cloudwatch_logs_exports :
      contains(["audit", "profiler"], log_type)
    ])
    error_message = "Allowed log types are: audit, profiler."
  }
}

# =============================================================================
# PARAMETER GROUP CONFIGURATION
# =============================================================================

variable "parameter_group_config" {
  description = "DB cluster parameter group configuration"
  type = object({
    create = optional(bool, false)
    family = optional(string, "docdb4.0")
    parameters = optional(list(object({
      name  = string
      value = string
    })), [])
  })
  default = {
    create = false
    family = "docdb4.0"
    parameters = [
      {
        name  = "tls"
        value = "enabled"
      }
    ]
  }
}
