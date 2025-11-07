variable "cluster_identifier" {
  description = "The cluster identifier"
  type        = string
  default     = "multi-az-docdb-cluster"
}

variable "master_username" {
  description = "Username for the master DB user"
  type        = string
  default     = "docdbadmin"
}

variable "instance_count" {
  description = "Number of instances in the cluster"
  type        = number
  default     = 3
}

variable "instance_class" {
  description = "The instance class to use"
  type        = string
  default     = "db.r5.large"
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the DocumentDB cluster"
  type        = list(string)
  default     = []
}

variable "allowed_security_group_ids" {
  description = "List of security group IDs allowed to access the DocumentDB cluster"
  type        = list(string)
  default     = []
}

variable "secret_recovery_window_in_days" {
  description = "Number of days that AWS Secrets Manager waits before it can delete the secret"
  type        = number
  default     = 30
}

variable "kms_key_description" {
  description = "Description for the KMS key"
  type        = string
  default     = "DocumentDB cluster encryption key for multi-AZ cluster"
}

variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = 30
}

variable "preferred_backup_window" {
  description = "The daily time range during which automated backups are created"
  type        = string
  default     = "03:00-05:00"
}

variable "preferred_maintenance_window" {
  description = "The weekly time range during which system maintenance can occur"
  type        = string
  default     = "sun:02:00-sun:03:00"
}

variable "deletion_protection" {
  description = "A value that indicates whether the DB cluster has deletion protection enabled"
  type        = bool
  default     = true
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to cloudwatch"
  type        = list(string)
  default     = ["audit", "profiler"]
}

variable "db_cluster_parameter_group_family" {
  description = "The DB cluster parameter group family"
  type        = string
  default     = "docdb4.0"
}

variable "db_cluster_parameter_group_parameters" {
  description = "A list of DB cluster parameters to apply"
  type = list(object({
    name  = string
    value = string
  }))
  default = [
    {
      name  = "tls"
      value = "enabled"
    },
    {
      name  = "audit_logs"
      value = "enabled"
    },
    {
      name  = "profiler"
      value = "enabled"
    },
    {
      name  = "profiler_threshold_ms"
      value = "100"
    }
  ]
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "multi-az-docdb"
}

variable "extra_tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}
