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

  subnet_ids = var.subnet_ids
  vpc_id     = var.vpc_id

  allowed_cidr_blocks        = var.allowed_cidr_blocks
  allowed_security_group_ids = var.allowed_security_group_ids

  # Enable Secrets Manager integration
  create_secret                  = true
  secret_name                    = var.secret_name
  secret_recovery_window_in_days = var.secret_recovery_window_in_days

  # Enable KMS encryption
  create_kms_key      = true
  kms_key_description = var.kms_key_description

  # Enhanced backup configuration
  backup_retention_period      = var.backup_retention_period
  preferred_backup_window      = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window

  storage_encrypted   = true
  deletion_protection = var.deletion_protection
  skip_final_snapshot = true

  # Enable CloudWatch logs
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  # Custom parameter group
  create_db_cluster_parameter_group     = true
  db_cluster_parameter_group_family     = var.db_cluster_parameter_group_family
  db_cluster_parameter_group_parameters = var.db_cluster_parameter_group_parameters

  tags = module.tags.tags
}
