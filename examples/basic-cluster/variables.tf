variable "cluster_identifier" {
  description = "The cluster identifier"
  type        = string
  default     = "basic-docdb-cluster"
}

variable "master_username" {
  description = "Username for the master DB user"
  type        = string
  default     = "docdbadmin"
}


variable "instance_count" {
  description = "Number of instances in the cluster"
  type        = number
  default     = 1
}

variable "instance_class" {
  description = "The instance class to use"
  type        = string
  default     = "db.t3.medium"
}

variable "vpc_name" {
  description = "Name of the VPC to use"
  type        = string
  default     = "arc-poc-vpc"
}


variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "The daily time range during which automated backups are created"
  type        = string
  default     = "07:00-09:00"
}

variable "preferred_maintenance_window" {
  description = "The weekly time range during which system maintenance can occur"
  type        = string
  default     = "sun:05:00-sun:06:00"
}

variable "storage_encrypted" {
  description = "Specifies whether the DB cluster is encrypted"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "A value that indicates whether the DB cluster has deletion protection enabled"
  type        = bool
  default     = false
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "basic-docdb"
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot when destroying cluster"
  type        = bool
  default     = false
}
