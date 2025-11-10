module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.5"

  environment = var.environment
  project     = var.project

  extra_tags = var.extra_tags
}

module "documentdb_cluster" {
  source = "../../"

  cluster_identifier = var.cluster_identifier
  master_username    = var.master_username

  instance_count = var.instance_count
  instance_class = var.instance_class

  subnet_config = {
    subnet_ids = data.aws_subnets.private.ids
  }
  vpc_id = data.aws_vpc.main.id

  allowed_cidr_blocks        = var.allowed_cidr_blocks
  allowed_security_group_ids = var.allowed_security_group_ids

  # Enable Secrets Manager integration
  secret_config = {
    create                  = true
    name                    = null # Use auto-generated name with random suffix
    recovery_window_in_days = var.secret_recovery_window_in_days
  }

  # Enable KMS encryption
  kms_config = {
    create_key  = true
    description = var.kms_key_description
  }

  # Enhanced backup configuration
  backup_retention_period      = var.backup_retention_period
  preferred_backup_window      = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window

  storage_encrypted   = true
  deletion_protection = var.deletion_protection
  skip_final_snapshot = true

  # Enable CloudWatch logs
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  # Parameter group configuration
  parameter_group_config = {
    create     = true
    family     = var.db_cluster_parameter_group_family
    parameters = var.db_cluster_parameter_group_parameters
  }

  tags = module.tags.tags
}
