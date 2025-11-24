# Tags module
module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.5"

  environment = var.environment
  project     = var.project

}

## Primary cluster in us-east-1
module "primary_cluster" {
  source = "../../"

  providers = {
    aws = aws.primary
  }

  cluster_identifier = var.primary_cluster_identifier
  master_username    = var.master_username
  # Note: manage_master_user_password is not supported for global clusters
  manage_master_user_password = false

  instance_count = var.primary_instance_count
  instance_class = var.primary_instance_class

  subnet_config = {
    subnet_ids = data.aws_subnets.primary_private.ids
  }
  vpc_id = data.aws_vpc.primary.id
  # Use security group rules
  security_group_data = local.primary_security_group_data

  # Global cluster configuration
  create_global_cluster     = true
  global_cluster_identifier = var.global_cluster_identifier

  # Security features
  secret_config = {
    create = true
  }
  kms_config = {
    create_key = true
  }
  storage_encrypted   = true
  deletion_protection = var.deletion_protection

  # Monitoring
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  # Enhanced backup
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot

  tags = module.tags.tags
}

# Secondary cluster in us-west-2
module "secondary_cluster" {
  source = "../../"

  providers = {
    aws = aws.secondary
  }

  cluster_identifier = var.secondary_cluster_identifier
  # Note: For fresh global cluster creation, don't specify master_username for secondary clusters
  # AWS manages username automatically. Only use master_username_for_secondary_cluster
  # when joining existing/external global clusters (conversion scenarios)
  # master_username_for_secondary_cluster = var.master_username  # Uncomment only for conversion scenarios

  # Password is still required even for secondary clusters
  # Note: manage_master_user_password is not supported for global clusters
  manage_master_user_password = false

  # Use Secrets Manager for password (recommended for global clusters)
  secret_config = {
    create = true
  }

  instance_count = var.secondary_instance_count
  instance_class = var.secondary_instance_class

  subnet_config = {
    subnet_ids = data.aws_subnets.secondary_private.ids
  }
  vpc_id = data.aws_vpc.secondary.id

  # Use security group rules
  security_group_data = local.secondary_security_group_data

  # Global cluster configuration
  existing_global_cluster_identifier = module.primary_cluster.global_cluster_identifier
  is_secondary_cluster               = true

  deletion_protection = var.deletion_protection
  skip_final_snapshot = var.skip_final_snapshot

  # Monitoring
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  tags                            = module.tags.tags

  depends_on = [module.primary_cluster]
}
