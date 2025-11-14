variable "cluster_identifier" {
  description = "The cluster identifier. If omitted, Terraform will assign a random, unique identifier"
  type        = string
  default     = null
}

variable "engine" {
  description = "The name of the database engine to be used for this DB cluster"
  type        = string
  default     = "docdb"
  validation {
    condition     = var.engine == "docdb"
    error_message = "Engine must be 'docdb' for DocumentDB clusters."
  }
}

variable "engine_version" {
  description = "The database engine version"
  type        = string
  default     = "4.0.0"
}

variable "master_username" {
  description = "Username for the master DB user"
  type        = string
  default     = "docdbadmin"
  validation {
    condition     = length(var.master_username) >= 1 && length(var.master_username) <= 63
    error_message = "Master username must be between 1 and 63 characters."
  }
}

variable "manage_master_user_password" {
  description = "Set to true to allow RDS to manage the master user password in Secrets Manager"
  type        = bool
  default     = true
}

variable "master_password" {
  description = "Password for the master DB user. If not provided and create_secret is true, will be auto-generated"
  type        = string
  default     = null
  sensitive   = true
}

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
  description = "The weekly time range during which system maintenance can occur"
  type        = string
  default     = "sun:05:00-sun:06:00"
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB cluster is deleted"
  type        = bool
  default     = false
}

variable "final_snapshot_identifier" {
  description = "The name of your final DB snapshot when this DB cluster is deleted"
  type        = string
  default     = null
}

variable "apply_immediately" {
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window"
  type        = bool
  default     = true
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB cluster during the maintenance window"
  type        = bool
  default     = true
}

variable "storage_encrypted" {
  description = "Specifies whether the DB cluster is encrypted"
  type        = bool
  default     = true
}

variable "kms_config" {
  description = "KMS configuration for DocumentDB encryption"
  type = object({
    key_id      = optional(string, null)
    create_key  = optional(bool, false)
    description = optional(string, "DocumentDB cluster encryption key")
  })
  default = {}
}

variable "subnet_config" {
  description = "Subnet configuration for DocumentDB cluster"
  type = object({
    group_name   = optional(string, null)
    create_group = optional(bool, true)
    subnet_ids   = optional(list(string), [])
  })
  default = {}
  validation {
    condition     = length(var.subnet_config.subnet_ids) >= 2 || length(var.subnet_config.subnet_ids) == 0
    error_message = "At least 2 subnet IDs must be provided when specifying subnet_ids."
  }
}

variable "create_security_group" {
  description = "Whether to create a security group for the DocumentDB cluster"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
  default     = null
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with the DocumentDB cluster"
  type        = list(string)
  default     = []
}


variable "security_group_data" {
  type = object({
    security_group_ids_to_attach = optional(list(string), [])
    create                       = optional(bool, true)
    description                  = optional(string, null)
    ingress_rules = optional(list(object({
      description              = optional(string, null)
      cidr_block               = optional(string, null)
      source_security_group_id = optional(string, null)
      from_port                = number
      ip_protocol              = string
      to_port                  = string
      self                     = optional(bool, false)
    })), [])
    egress_rules = optional(list(object({
      description                   = optional(string, null)
      cidr_block                    = optional(string, null)
      destination_security_group_id = optional(string, null)
      from_port                     = number
      ip_protocol                   = string
      to_port                       = string
      prefix_list_id                = optional(string, null)
    })), [])
  })
  description = "(optional) Security Group data"
  default = {
    create = false
  }
}


variable "parameter_group_config" {
  description = "DB cluster parameter group configuration"
  type = object({
    name   = optional(string, null)
    create = optional(bool, false)
    family = optional(string, "docdb4.0")
    parameters = optional(list(object({
      name  = string
      value = string
    })), [])
  })
  default = {}
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to cloudwatch"
  type        = list(string)
  default     = []
  validation {
    condition = alltrue([
      for log_type in var.enabled_cloudwatch_logs_exports :
      contains(["audit", "profiler"], log_type)
    ])
    error_message = "Enabled CloudWatch logs exports must be one of: audit, profiler."
  }
}

variable "deletion_protection" {
  description = "A value that indicates whether the DB cluster has deletion protection enabled"
  type        = bool
  default     = false
}

variable "port" {
  description = "The port on which the DB accepts connections"
  type        = number
  default     = 27017
}

variable "instance_count" {
  description = "Number of instances in the cluster"
  type        = number
  default     = 1
  validation {
    condition     = var.instance_count >= 1 && var.instance_count <= 16
    error_message = "Instance count must be between 1 and 16."
  }
}

variable "instance_class" {
  description = "The instance class to use"
  type        = string
  default     = "db.t3.medium"
}

variable "secret_config" {
  description = "Secrets Manager configuration for DocumentDB credentials"
  type = object({
    create                  = optional(bool, false)
    name                    = optional(string, null)
    description             = optional(string, "DocumentDB cluster master credentials")
    recovery_window_in_days = optional(number, 7)
  })
  default = {}
  validation {
    condition     = var.secret_config.recovery_window_in_days >= 7 && var.secret_config.recovery_window_in_days <= 30
    error_message = "Secret recovery window must be between 7 and 30 days."
  }
}

variable "create_global_cluster" {
  description = "Whether to create a DocumentDB Global Cluster"
  type        = bool
  default     = false
}

variable "global_cluster_identifier" {
  description = "The global cluster identifier"
  type        = string
  default     = null
}

variable "source_db_cluster_identifier" {
  description = "The identifier of the source cluster for global cluster"
  type        = string
  default     = null
}


variable "is_secondary_cluster" {
  description = "Whether this cluster is a secondary cluster in a global cluster"
  type        = bool
  default     = false
}

variable "existing_global_cluster_identifier" {
  description = "The identifier of an existing global cluster to join"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "name_prefix" {
  description = "Name prefix for resources"
  type        = string
  default     = "docdb"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

# Additional comprehensive variables for all DocumentDB features

variable "cluster_identifier_prefix" {
  description = "Creates a unique cluster identifier beginning with the specified prefix"
  type        = string
  default     = null
}

variable "database_name" {
  description = "The name of the database to create when the DB cluster is created"
  type        = string
  default     = null
}

variable "copy_tags_to_snapshot" {
  description = "Copy all Cluster tags to snapshots"
  type        = bool
  default     = false
}

variable "snapshot_identifier" {
  description = "Specifies whether or not to create this cluster from a snapshot"
  type        = string
  default     = null
}

variable "allow_major_version_upgrade" {
  description = "Enable to allow major engine version upgrades when changing engine versions"
  type        = bool
  default     = false
}

variable "availability_zones" {
  description = "A list of EC2 Availability Zones for the DB cluster storage where DB cluster instances can be created"
  type        = list(string)
  default     = null
}

variable "instance_identifier_prefix" {
  description = "Creates a unique identifier beginning with the specified prefix"
  type        = string
  default     = null
}

variable "instance_promotion_tiers" {
  description = "Map of instance index to promotion tier (0-15). Lower number = higher priority for promotion"
  type        = map(number)
  default     = {}
  validation {
    condition = alltrue([
      for tier in values(var.instance_promotion_tiers) :
      tier >= 0 && tier <= 15
    ])
    error_message = "Promotion tier must be between 0 and 15."
  }
}

variable "monitoring_interval" {
  description = "The interval for collecting enhanced monitoring metrics. Valid values: 0, 1, 5, 10, 15, 30, 60"
  type        = number
  default     = 0
  validation {
    condition     = contains([0, 1, 5, 10, 15, 30, 60], var.monitoring_interval)
    error_message = "Monitoring interval must be one of: 0, 1, 5, 10, 15, 30, 60."
  }
}


variable "create_monitoring_role" {
  description = "Whether to create an IAM role for enhanced monitoring"
  type        = bool
  default     = false
}

variable "instance_availability_zones" {
  description = "List of availability zones for instances. If not specified, instances will be distributed across available AZs"
  type        = list(string)
  default     = null
}

variable "ca_cert_identifier" {
  description = "The identifier of the CA certificate for the DB instance"
  type        = string
  default     = null
}

variable "db_parameter_group_name" {
  description = "Name of the DB parameter group to associate with instances"
  type        = string
  default     = null
}



variable "db_subnet_group_description" {
  description = "Description for the DB subnet group"
  type        = string
  default     = "DocumentDB subnet group"
}

variable "db_cluster_parameter_group_description" {
  description = "Description for the DB cluster parameter group"
  type        = string
  default     = "DocumentDB cluster parameter group"
}

variable "force_overwrite_replica_secret" {
  description = "Accepts boolean value to specify whether to overwrite a secret with the same name in the destination Region"
  type        = bool
  default     = false
}

variable "replica_region" {
  description = "Region for replicating the secret"
  type        = string
  default     = null
}

variable "replica_kms_key_id" {
  description = "KMS key ID for replica secret encryption"
  type        = string
  default     = null
}

variable "secret_version_stages" {
  description = "Specifies text data that you want to encrypt and store in this version of the secret"
  type        = list(string)
  default     = null
}

variable "event_subscription_config" {
  description = "Configuration for RDS event subscription"
  type = object({
    create           = optional(bool, false)
    name             = optional(string, null)
    sns_topic_arn    = optional(string, null)
    enabled          = optional(bool, true)
    source_type      = optional(string, "db-cluster")
    source_ids       = optional(list(string), [])
    event_categories = optional(list(string), [])
  })
  default = {}
  validation {
    condition = contains([
      "db-instance", "db-cluster", "db-parameter-group",
      "db-security-group", "db-snapshot", "db-cluster-snapshot"
    ], var.event_subscription_config.source_type)
    error_message = "Event source type must be one of: db-instance, db-cluster, db-parameter-group, db-security-group, db-snapshot, db-cluster-snapshot."
  }
}

variable "cloudwatch_log_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group"
  type        = number
  default     = 7
  validation {
    condition = contains([
      1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653
    ], var.cloudwatch_log_retention_in_days)
    error_message = "CloudWatch log retention must be a valid value."
  }
}

variable "cloudwatch_log_kms_key_id" {
  description = "The ARN of the KMS Key to use when encrypting log data"
  type        = string
  default     = null
}

variable "alarm_config" {
  description = "CloudWatch alarm configuration for DocumentDB monitoring"
  type = object({
    create_alarms = optional(bool, false)
    cpu = optional(object({
      threshold          = optional(number, 80)
      evaluation_periods = optional(number, 2)
      period             = optional(number, 300)
    }), {})
    connections = optional(object({
      threshold          = optional(number, 80)
      evaluation_periods = optional(number, 2)
      period             = optional(number, 300)
    }), {})
    alarm_actions = optional(list(string), [])
    ok_actions    = optional(list(string), [])
  })
  default = {}
}

variable "treat_missing_data" {
  description = "Sets how this alarm is to handle missing data points"
  type        = string
  default     = "missing"
  validation {
    condition     = contains(["breaching", "notBreaching", "ignore", "missing"], var.treat_missing_data)
    error_message = "Treat missing data must be one of: breaching, notBreaching, ignore, missing."
  }
}
variable "additional_policy_arns" {
  description = "List of additional IAM policy ARNs to attach to the Lambda role"
  type        = list(string)
  default     = []
}
