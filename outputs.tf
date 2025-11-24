output "global_cluster_arn" {
  description = "Amazon Resource Name (ARN) of the global cluster"
  value       = var.create_global_cluster ? aws_docdb_global_cluster.this[0].arn : (var.convert_to_global_cluster ? aws_docdb_global_cluster.conversion[0].arn : null)
}

output "global_cluster_id" {
  description = "The DocumentDB global cluster identifier"
  value       = var.create_global_cluster ? aws_docdb_global_cluster.this[0].id : (var.convert_to_global_cluster ? aws_docdb_global_cluster.conversion[0].id : null)
}

output "global_cluster_identifier" {
  description = "The DocumentDB global cluster identifier"
  value       = var.create_global_cluster ? aws_docdb_global_cluster.this[0].global_cluster_identifier : (var.convert_to_global_cluster ? aws_docdb_global_cluster.conversion[0].global_cluster_identifier : null)
}

output "global_cluster_resource_id" {
  description = "The DocumentDB Global Cluster Resource ID"
  value       = var.create_global_cluster ? aws_docdb_global_cluster.this[0].global_cluster_resource_id : (var.convert_to_global_cluster ? aws_docdb_global_cluster.conversion[0].global_cluster_resource_id : null)
}

output "global_cluster_members" {
  description = "List of DocumentDB Clusters that are part of this global cluster"
  value       = var.create_global_cluster ? aws_docdb_global_cluster.this[0].global_cluster_members : (var.convert_to_global_cluster ? aws_docdb_global_cluster.conversion[0].global_cluster_members : null)
}

output "cluster_arn" {
  description = "Amazon Resource Name (ARN) of the cluster"
  value       = aws_docdb_cluster.this.arn
}

output "cluster_id" {
  description = "The DocumentDB cluster identifier"
  value       = aws_docdb_cluster.this.id
}

output "cluster_identifier" {
  description = "The DocumentDB cluster identifier"
  value       = aws_docdb_cluster.this.cluster_identifier
}

output "cluster_endpoint" {
  description = "The DNS address of the DocumentDB instance"
  value       = aws_docdb_cluster.this.endpoint
}

output "cluster_reader_endpoint" {
  description = "A read-only endpoint for the DocumentDB cluster, automatically load-balanced across replicas"
  value       = aws_docdb_cluster.this.reader_endpoint
}

output "cluster_port" {
  description = "The database port"
  value       = aws_docdb_cluster.this.port
}

output "cluster_hosted_zone_id" {
  description = "The Route53 Hosted Zone ID of the endpoint"
  value       = aws_docdb_cluster.this.hosted_zone_id
}

output "cluster_resource_id" {
  description = "The DocumentDB Cluster Resource ID"
  value       = aws_docdb_cluster.this.cluster_resource_id
}

output "cluster_members" {
  description = "List of DocumentDB Instances that are a part of this cluster"
  value       = aws_docdb_cluster.this.cluster_members
}

output "instance_ids" {
  description = "List of DocumentDB instance identifiers"
  value       = aws_docdb_cluster_instance.this[*].id
}

output "instance_arns" {
  description = "List of DocumentDB instance ARNs"
  value       = aws_docdb_cluster_instance.this[*].arn
}

output "instance_endpoints" {
  description = "List of DocumentDB instance endpoints"
  value       = aws_docdb_cluster_instance.this[*].endpoint
}

output "db_subnet_group_name" {
  description = "The name of the DB subnet group"
  value       = var.subnet_config.create_group ? aws_docdb_subnet_group.this[0].name : var.subnet_config.group_name
}

output "db_cluster_parameter_group_name" {
  description = "The name of the DB cluster parameter group"
  value       = var.parameter_group_config.create ? aws_docdb_cluster_parameter_group.this[0].name : var.parameter_group_config.name
}

output "security_group_id" {
  description = "The ID of the security group created for the DocumentDB cluster"
  value       = var.create_security_group ? module.security_group[0].id : null
}

output "security_group_arn" {
  description = "The ARN of the security group created for the DocumentDB cluster"
  value       = var.create_security_group ? module.security_group[0].id : null
}

output "kms_key_id" {
  description = "The globally unique identifier for the key"
  value       = var.kms_config.create_key ? module.kms[0].key_id : null
}

output "kms_key_arn" {
  description = "The Amazon Resource Name (ARN) of the key"
  value       = var.kms_config.create_key ? module.kms[0].key_arn : null
}

output "secret_arn" {
  description = "The ARN of the secret"
  value       = var.secret_config.create ? aws_secretsmanager_secret.this[0].arn : null
}

output "secret_id" {
  description = "The ID of the secret"
  value       = var.secret_config.create ? aws_secretsmanager_secret.this[0].id : null
}

output "master_username" {
  description = "The master username for the DB cluster"
  value       = var.master_username
}

# Additional comprehensive outputs

output "cluster_database_name" {
  description = "The name of the database"
  value       = var.database_name
}

output "cluster_engine" {
  description = "The database engine"
  value       = aws_docdb_cluster.this.engine
}

output "cluster_engine_version" {
  description = "The database engine version"
  value       = aws_docdb_cluster.this.engine_version
}

output "cluster_backup_retention_period" {
  description = "The backup retention period"
  value       = aws_docdb_cluster.this.backup_retention_period
}

output "cluster_preferred_backup_window" {
  description = "The daily time range during which the backups happen"
  value       = aws_docdb_cluster.this.preferred_backup_window
}

output "cluster_preferred_maintenance_window" {
  description = "The weekly time range during which system maintenance can occur"
  value       = aws_docdb_cluster.this.preferred_maintenance_window
}

output "cluster_storage_encrypted" {
  description = "Specifies whether the DB cluster is encrypted"
  value       = aws_docdb_cluster.this.storage_encrypted
}

output "cluster_kms_key_id" {
  description = "The ARN for the KMS encryption key"
  value       = aws_docdb_cluster.this.kms_key_id
}

output "cluster_availability_zones" {
  description = "The availability zones of the cluster"
  value       = aws_docdb_cluster.this.availability_zones
}

output "cluster_vpc_security_group_ids" {
  description = "List of VPC security groups associated to the cluster"
  value       = aws_docdb_cluster.this.vpc_security_group_ids
}

output "cluster_enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to cloudwatch"
  value       = aws_docdb_cluster.this.enabled_cloudwatch_logs_exports
}

output "cluster_deletion_protection" {
  description = "Specifies whether the cluster has deletion protection enabled"
  value       = aws_docdb_cluster.this.deletion_protection
}

output "instance_identifiers" {
  description = "List of DocumentDB instance identifiers"
  value       = aws_docdb_cluster_instance.this[*].identifier
}

output "instance_classes" {
  description = "List of DocumentDB instance classes"
  value       = aws_docdb_cluster_instance.this[*].instance_class
}

output "instance_availability_zones" {
  description = "List of availability zones for the instances"
  value       = aws_docdb_cluster_instance.this[*].availability_zone
}

output "instance_engines" {
  description = "List of database engines for the instances"
  value       = aws_docdb_cluster_instance.this[*].engine
}

output "instance_engine_versions" {
  description = "List of database engine versions for the instances"
  value       = aws_docdb_cluster_instance.this[*].engine_version
}

output "instance_ports" {
  description = "List of database ports for the instances"
  value       = aws_docdb_cluster_instance.this[*].port
}

output "instance_writers" {
  description = "List indicating which instances are writers"
  value       = aws_docdb_cluster_instance.this[*].writer
}

output "instance_promotion_tiers" {
  description = "List of promotion tiers for the instances"
  value       = aws_docdb_cluster_instance.this[*].promotion_tier
}

output "instance_ca_cert_identifiers" {
  description = "List of CA certificate identifiers for the instances"
  value       = aws_docdb_cluster_instance.this[*].ca_cert_identifier
}

output "instance_performance_insights_kms_key_ids" {
  description = "List of KMS key identifiers for Performance Insights encryption"
  value       = aws_docdb_cluster_instance.this[*].performance_insights_kms_key_id
}

output "db_parameter_group_name" {
  description = "The name of the DB parameter group"
  value       = var.db_parameter_group_name
}

output "db_parameter_group_arn" {
  description = "The ARN of the DB parameter group"
  value       = null
}

output "db_cluster_parameter_group_arn" {
  description = "The ARN of the DB cluster parameter group"
  value       = var.parameter_group_config.create ? aws_docdb_cluster_parameter_group.this[0].arn : null
}

output "db_subnet_group_arn" {
  description = "The ARN of the DB subnet group"
  value       = var.subnet_config.create_group ? aws_docdb_subnet_group.this[0].arn : null
}

output "event_subscription_arn" {
  description = "The ARN of the DocumentDB event subscription"
  value       = var.event_subscription_config.create ? aws_docdb_event_subscription.this[0].arn : null
}

output "event_subscription_id" {
  description = "The ID of the DocumentDB event subscription"
  value       = var.event_subscription_config.create ? aws_docdb_event_subscription.this[0].id : null
}

output "cloudwatch_log_group_audit_name" {
  description = "The name of the CloudWatch log group for audit logs"
  value       = contains(var.enabled_cloudwatch_logs_exports, "audit") ? aws_cloudwatch_log_group.audit[0].name : null
}

output "cloudwatch_log_group_profiler_name" {
  description = "The name of the CloudWatch log group for profiler logs"
  value       = contains(var.enabled_cloudwatch_logs_exports, "profiler") ? aws_cloudwatch_log_group.profiler[0].name : null
}

output "cloudwatch_log_group_audit_arn" {
  description = "The ARN of the CloudWatch log group for audit logs"
  value       = contains(var.enabled_cloudwatch_logs_exports, "audit") ? aws_cloudwatch_log_group.audit[0].arn : null
}

output "cloudwatch_log_group_profiler_arn" {
  description = "The ARN of the CloudWatch log group for profiler logs"
  value       = contains(var.enabled_cloudwatch_logs_exports, "profiler") ? aws_cloudwatch_log_group.profiler[0].arn : null
}

output "cloudwatch_alarm_cpu_arns" {
  description = "List of ARNs for CPU utilization CloudWatch alarms"
  value       = var.alarm_config.create_alarms ? aws_cloudwatch_metric_alarm.cpu_utilization[*].arn : []
}

output "cloudwatch_alarm_connection_arns" {
  description = "List of ARNs for database connection CloudWatch alarms"
  value       = var.alarm_config.create_alarms ? aws_cloudwatch_metric_alarm.database_connections[*].arn : []
}

output "enhanced_monitoring_role_arn" {
  description = "The ARN of the enhanced monitoring IAM role"
  value       = var.monitoring_interval > 0 && var.create_monitoring_role ? aws_iam_role.enhanced_monitoring[0].arn : null
}

output "enhanced_monitoring_role_name" {
  description = "The name of the enhanced monitoring IAM role"
  value       = var.monitoring_interval > 0 && var.create_monitoring_role ? aws_iam_role.enhanced_monitoring[0].name : null
}
