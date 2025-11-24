# Data source for current AWS account
data "aws_caller_identity" "current" {}

# Random password for master user
resource "random_password" "master" {
  count            = var.secret_config.create && var.master_password == null ? 1 : 0
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1
}
resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "random_id" "secret_suffix" {
  byte_length = 4
  keepers = {
    cluster_identifier = var.cluster_identifier
  }
}
# KMS Key using SourceFuse module
module "kms" {
  count   = var.kms_config.create_key ? 1 : 0
  source  = "sourcefuse/arc-kms/aws"
  version = "0.0.1"

  alias       = "alias/${var.name_prefix}-${var.environment}-docdb-${random_string.suffix.result}"
  description = var.kms_config.description
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
  tags = var.tags
}

# Secrets Manager secret
resource "aws_secretsmanager_secret" "this" {
  count                          = var.secret_config.create ? 1 : 0
  name                           = local.secret_name
  description                    = var.secret_config.description
  recovery_window_in_days        = var.secret_config.recovery_window_in_days
  kms_key_id                     = local.kms_key_id
  force_overwrite_replica_secret = var.force_overwrite_replica_secret

  lifecycle {
    create_before_destroy = true
  }

  dynamic "replica" {
    for_each = var.replica_region != null ? [1] : []
    content {
      region     = var.replica_region
      kms_key_id = var.replica_kms_key_id
    }
  }
  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "this" {
  count     = var.secret_config.create ? 1 : 0
  secret_id = aws_secretsmanager_secret.this[0].id
  secret_string = jsonencode({
    username = var.master_username
    password = local.master_password
    engine   = var.engine
    host     = aws_docdb_cluster.this.endpoint
    port     = var.port
    dbname   = var.database_name
  })
  version_stages = var.secret_version_stages
}

# DocumentDB Global Cluster
resource "aws_docdb_global_cluster" "this" {
  count                        = var.create_global_cluster ? 1 : 0
  global_cluster_identifier    = local.global_cluster_identifier
  source_db_cluster_identifier = var.source_db_cluster_identifier
  engine                       = var.engine
  engine_version               = var.engine_version
  storage_encrypted            = var.storage_encrypted
  deletion_protection          = var.deletion_protection
  database_name                = var.database_name
}

# DB Subnet Group
resource "aws_docdb_subnet_group" "this" {
  count       = var.subnet_config.create_group ? 1 : 0
  name        = local.db_subnet_group_name
  description = var.db_subnet_group_description
  subnet_ids  = var.subnet_config.subnet_ids
  tags        = var.tags
}

# Security Group
module "security_group" {
  count   = var.create_security_group ? 1 : 0
  source  = "sourcefuse/arc-security-group/aws"
  version = "0.0.2"

  name          = "${var.name_prefix}-${var.environment}-sg"
  description   = "Security group for DocumentDB cluster"
  vpc_id        = var.vpc_id
  ingress_rules = var.security_group_data.ingress_rules
  egress_rules  = var.security_group_data.egress_rules

  tags = var.tags
}

# DB Cluster Parameter Group
resource "aws_docdb_cluster_parameter_group" "this" {
  count       = var.parameter_group_config.create ? 1 : 0
  family      = var.parameter_group_config.family
  name        = local.db_cluster_parameter_group_name
  description = var.db_cluster_parameter_group_description
  tags        = var.tags

  dynamic "parameter" {
    for_each = var.parameter_group_config.parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = lookup(parameter.value, "apply_method", "pending-reboot")
    }
  }
}

# DocumentDB Event Subscription
resource "aws_docdb_event_subscription" "this" {
  count            = var.event_subscription_config.create ? 1 : 0
  name             = local.event_subscription_name
  sns_topic_arn    = var.event_subscription_config.sns_topic_arn
  source_type      = var.event_subscription_config.source_type
  source_ids       = var.event_subscription_config.source_ids
  event_categories = var.event_subscription_config.event_categories
  enabled          = var.event_subscription_config.enabled
  tags             = var.tags
}

# DocumentDB Cluster
resource "aws_docdb_cluster" "this" {
  # Basic Configuration
  cluster_identifier        = local.cluster_identifier
  cluster_identifier_prefix = var.cluster_identifier_prefix
  global_cluster_identifier = var.is_secondary_cluster ? var.existing_global_cluster_identifier : (var.create_global_cluster ? aws_docdb_global_cluster.this[0].id : null)


  # Engine Configuration
  engine         = var.engine
  engine_version = var.engine_version

  # Authentication
  # For secondary clusters: only specify username when explicitly provided (conversion scenarios)
  # For fresh global cluster creation, leave username null so AWS manages authentication automatically
  master_username             = var.is_secondary_cluster ? var.master_username_for_secondary_cluster : var.master_username
  master_password             = var.is_secondary_cluster ? null : (var.create_global_cluster ? local.master_password : (var.manage_master_user_password ? null : local.master_password))
  manage_master_user_password = var.create_global_cluster || var.is_secondary_cluster ? null : (var.manage_master_user_password ? true : null)


  # Database Configuration
  port = var.port

  # Backup Configuration
  backup_retention_period   = var.backup_retention_period
  preferred_backup_window   = var.preferred_backup_window
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.final_snapshot_identifier
  snapshot_identifier       = var.snapshot_identifier

  # Maintenance Configuration
  preferred_maintenance_window = var.preferred_maintenance_window
  apply_immediately            = var.apply_immediately
  allow_major_version_upgrade  = var.allow_major_version_upgrade

  # Security Configuration
  storage_encrypted   = var.storage_encrypted
  kms_key_id          = local.kms_key_id
  deletion_protection = var.deletion_protection

  # Network Configuration
  db_subnet_group_name   = local.db_subnet_group_name
  vpc_security_group_ids = local.security_group_ids
  availability_zones     = var.availability_zones

  # Parameter Groups
  db_cluster_parameter_group_name = local.db_cluster_parameter_group_name

  # Logging Configuration
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  tags = var.tags

  lifecycle {
    precondition {
      condition     = !var.is_secondary_cluster || var.existing_global_cluster_identifier != null
      error_message = "existing_global_cluster_identifier is required when is_secondary_cluster is true."
    }

    precondition {
      condition     = !(var.create_global_cluster && var.manage_master_user_password) && !(var.is_secondary_cluster && var.manage_master_user_password)
      error_message = "manage_master_user_password is not supported for global clusters. Set manage_master_user_password = false and provide an explicit master_password or use secret_config.create = true."
    }

    ignore_changes = [
      master_password,
      global_cluster_identifier,
      snapshot_identifier
    ]
  }

  depends_on = [
    aws_docdb_subnet_group.this,
    aws_docdb_cluster_parameter_group.this,
    aws_docdb_global_cluster.this
  ]
}

# DocumentDB Cluster Instances
resource "aws_docdb_cluster_instance" "this" {
  count              = var.instance_count
  identifier         = var.instance_identifier_prefix != null ? "${var.instance_identifier_prefix}-${count.index + 1}" : "${local.cluster_identifier}-${count.index + 1}"
  cluster_identifier = aws_docdb_cluster.this.id

  # Instance Configuration
  instance_class = var.instance_class
  engine         = var.engine

  # Maintenance Configuration
  apply_immediately            = var.apply_immediately
  auto_minor_version_upgrade   = var.auto_minor_version_upgrade
  preferred_maintenance_window = var.preferred_maintenance_window

  # Performance Configuration
  promotion_tier = lookup(var.instance_promotion_tiers, count.index, 0)

  # Network Configuration
  availability_zone     = var.instance_availability_zones != null ? element(var.instance_availability_zones, count.index) : null
  ca_cert_identifier    = var.ca_cert_identifier
  copy_tags_to_snapshot = var.copy_tags_to_snapshot

  tags = merge(
    var.tags,
    {
      Name = var.instance_identifier_prefix != null ? "${var.instance_identifier_prefix}-${count.index + 1}" : "${local.cluster_identifier}-${count.index + 1}"
    }
  )
}

# CloudWatch Log Groups
resource "aws_cloudwatch_log_group" "audit" {
  count             = contains(var.enabled_cloudwatch_logs_exports, "audit") ? 1 : 0
  name              = "/aws/docdb/${aws_docdb_cluster.this.cluster_identifier}/audit"
  retention_in_days = var.cloudwatch_log_retention_in_days
  kms_key_id        = var.cloudwatch_log_kms_key_id
  tags              = var.tags
}

resource "aws_cloudwatch_log_group" "profiler" {
  count             = contains(var.enabled_cloudwatch_logs_exports, "profiler") ? 1 : 0
  name              = "/aws/docdb/${aws_docdb_cluster.this.cluster_identifier}/profiler"
  retention_in_days = var.cloudwatch_log_retention_in_days
  kms_key_id        = var.cloudwatch_log_kms_key_id
  tags              = var.tags
}

# CloudWatch Alarms
resource "aws_cloudwatch_metric_alarm" "cpu_utilization" {
  count               = var.alarm_config.create_alarms ? var.instance_count : 0
  alarm_name          = "${aws_docdb_cluster_instance.this[count.index].identifier}-cpu-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.alarm_config.cpu.evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/DocDB"
  period              = var.alarm_config.cpu.period
  statistic           = "Average"
  threshold           = var.alarm_config.cpu.threshold
  alarm_description   = "This metric monitors DocumentDB instance CPU utilization"
  alarm_actions       = var.alarm_config.alarm_actions
  ok_actions          = var.alarm_config.ok_actions
  treat_missing_data  = var.treat_missing_data

  dimensions = {
    DBInstanceIdentifier = aws_docdb_cluster_instance.this[count.index].identifier
  }

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "database_connections" {
  count               = var.alarm_config.create_alarms ? var.instance_count : 0
  alarm_name          = "${aws_docdb_cluster_instance.this[count.index].identifier}-database-connections"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.alarm_config.connections.evaluation_periods
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/DocDB"
  period              = var.alarm_config.connections.period
  statistic           = "Average"
  threshold           = var.alarm_config.connections.threshold
  alarm_description   = "This metric monitors DocumentDB instance database connections"
  alarm_actions       = var.alarm_config.alarm_actions
  ok_actions          = var.alarm_config.ok_actions
  treat_missing_data  = var.treat_missing_data

  dimensions = {
    DBInstanceIdentifier = aws_docdb_cluster_instance.this[count.index].identifier
  }

  tags = var.tags
}

# IAM Role for Enhanced Monitoring
resource "aws_iam_role" "enhanced_monitoring" {
  count = var.monitoring_interval > 0 && var.create_monitoring_role ? 1 : 0
  name  = "${var.name_prefix}-${var.environment}-docdb-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "enhanced_monitoring" {
  count      = var.monitoring_interval > 0 && var.create_monitoring_role ? 1 : 0
  role       = aws_iam_role.enhanced_monitoring[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# Attach additional user-provided policies to default role
resource "aws_iam_role_policy_attachment" "additional" {
  count      = var.monitoring_interval > 0 && var.create_monitoring_role ? 1 : 0
  role       = aws_iam_role.enhanced_monitoring[0].name
  policy_arn = var.additional_policy_arns[count.index]
}
