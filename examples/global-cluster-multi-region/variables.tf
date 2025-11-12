variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "global-docdb"
}


variable "global_cluster_identifier" {
  description = "The global cluster identifier"
  type        = string
  default     = "global-docdb-cluster"
}

variable "primary_region" {
  description = "Primary region for the global cluster"
  type        = string
  default     = "us-east-1"
}

variable "secondary_region" {
  description = "Secondary region for the global cluster"
  type        = string
  default     = "us-west-2"
}

variable "primary_cluster_identifier" {
  description = "The primary cluster identifier"
  type        = string
  default     = "primary-docdb-cluster"
}

variable "secondary_cluster_identifier" {
  description = "The secondary cluster identifier"
  type        = string
  default     = "secondary-docdb-cluster"
}

variable "master_username" {
  description = "Username for the master DB user"
  type        = string
  default     = "docdbadmin"
}

variable "primary_instance_count" {
  description = "Number of instances in the primary cluster"
  type        = number
  default     = 2
}

variable "secondary_instance_count" {
  description = "Number of instances in the secondary cluster"
  type        = number
  default     = 1
}

variable "primary_instance_class" {
  description = "The instance class for primary cluster"
  type        = string
  default     = "db.r5.large"
}

variable "secondary_instance_class" {
  description = "The instance class for secondary cluster"
  type        = string
  default     = "db.r5.large"
}


variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = 30
}

variable "deletion_protection" {
  description = "A value that indicates whether the clusters have deletion protection enabled"
  type        = bool
  default     = true
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to cloudwatch"
  type        = list(string)
  default     = ["audit", "profiler"]
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot when destroying clusters"
  type        = bool
  default     = false
}

variable "primary_vpc_name" {
  description = "VPC name in primary region"
  type        = string
}
