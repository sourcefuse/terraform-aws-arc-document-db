locals {
  # Cluster Configuration
  cluster_identifier = var.cluster_identifier != null ? var.cluster_identifier : "${var.name_prefix}-${var.environment}"

  # Global Cluster Configuration
  global_cluster_identifier = var.create_global_cluster ? (
    var.global_cluster_identifier != null ? var.global_cluster_identifier : "${var.name_prefix}-${var.environment}-global"
  ) : null

  # Master Password Logic
  master_password = var.master_password != null ? var.master_password : (
    var.secret_config.create && length(random_password.master) > 0 ? random_password.master[0].result : null
  )

  # KMS Key Configuration
  kms_key_id = var.kms_config.key_id != null ? var.kms_config.key_id : (
    var.kms_config.create_key && length(module.kms) > 0 ? module.kms[0].key_arn : null
  )

  # Secrets Manager Configuration
  secret_name = var.secret_config.name != null ? var.secret_config.name : "${var.cluster_identifier}-credentials-${random_id.secret_suffix.hex}"

  # Subnet Group Configuration
  db_subnet_group_name = var.subnet_config.group_name != null ? var.subnet_config.group_name : (
    var.subnet_config.create_group ? "${var.name_prefix}-${var.environment}-subnet-group" : null
  )

  # Security Group Configuration
  security_group_ids = concat(
    var.vpc_security_group_ids,
    var.security_group_ids,
    var.create_security_group && length(module.security_group) > 0 ? [module.security_group[0].id] : []
  )

  # Parameter Group Configuration
  db_cluster_parameter_group_name = var.parameter_group_config.name != null ? var.parameter_group_config.name : (
    var.parameter_group_config.create ? "${var.name_prefix}-${var.environment}-cluster-pg" : null
  )

  # Event Subscription Configuration
  event_subscription_name = var.event_subscription_name != null ? var.event_subscription_name : "${var.name_prefix}-${var.environment}-events"
}
