# =============================================================================
# CONVERSION SCENARIO: Convert Existing Multi-AZ Cluster to Global Cluster
# =============================================================================
# This example demonstrates converting an existing DocumentDB cluster that was
# originally created as a multi-AZ cluster into a global cluster with cross-region
# replication. This is a common scenario when you need to add disaster recovery
# capabilities to an existing production cluster.

# Common tags for all resources
module "tags" {
  source      = "sourcefuse/arc-tags/aws"
  version     = "1.2.3"
  environment = var.environment
  project     = var.project_name

  extra_tags = {
    Example      = "global-cluster-conversion"
    MonoRepo     = "True"
    MonoRepoPath = "examples/global-cluster-conversion"
  }
}

# =============================================================================
# PRIMARY CLUSTER (CONVERSION SCENARIO)
# =============================================================================
# This converts your existing Terraform-managed DocumentDB cluster to become
# the PRIMARY of a global cluster. The existing cluster will maintain its data
# and become the source for cross-region replication.

module "primary_cluster" {
  source = "../../"

  providers = {
    aws = aws.primary
  }

  # Basic Configuration
  environment        = var.environment
  cluster_identifier = var.primary_cluster_identifier

  # Instance Configuration
  instance_count = var.primary_instance_count
  instance_class = var.primary_instance_class

  # Engine Configuration
  engine_version = var.engine_version

  # Authentication - Keep existing credentials
  master_username = var.master_username
  # For conversion scenarios, use explicit password management
  manage_master_user_password = false
  master_password             = var.master_password

  # Network Configuration
  vpc_id = data.aws_vpc.primary.id
  subnet_config = {
    create_group = true
    subnet_ids   = local.primary_subnet_ids
  }
  security_group_data = local.primary_security_group_data

  # CONVERSION CONFIGURATION
  # ========================
  # This is the key difference from fresh global cluster creation
  convert_to_global_cluster = true # Convert existing cluster to global
  global_cluster_identifier = local.global_cluster_identifier

  # Security Configuration
  storage_encrypted   = var.storage_encrypted
  deletion_protection = var.deletion_protection

  # Backup Configuration
  backup_retention_period      = var.backup_retention_period
  preferred_backup_window      = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window
  skip_final_snapshot          = var.skip_final_snapshot

  # Monitoring Configuration
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  # Parameter Group (if using custom parameters)
  parameter_group_config = var.parameter_group_config

  tags = merge(
    module.tags.tags,
    {
      Name = var.primary_cluster_identifier
      Role = "Primary"
    }
  )
}

# =============================================================================
# SECONDARY CLUSTER (DISASTER RECOVERY)
# =============================================================================
# This creates a new secondary cluster in a different region that will
# automatically sync with the primary cluster for disaster recovery.

module "secondary_cluster" {
  source = "../../"

  providers = {
    aws = aws.secondary
  }

  # Basic Configuration
  environment        = "dr" # Different environment for DR
  cluster_identifier = local.secondary_cluster_identifier

  # Instance Configuration (can be different from primary)
  instance_count = var.secondary_instance_count
  instance_class = var.secondary_instance_class

  # Engine Configuration (must match primary)
  engine_version = var.engine_version

  # Authentication - AWS manages automatically for secondary clusters
  # Do NOT specify master_username or master_password for secondary clusters
  # AWS will automatically propagate authentication from primary

  # Network Configuration (different VPC in secondary region)
  vpc_id = data.aws_vpc.secondary.id
  subnet_config = {
    create_group = true
    subnet_ids   = local.secondary_subnet_ids
  }
  security_group_data = local.secondary_security_group_data

  # SECONDARY CLUSTER CONFIGURATION
  # ===============================
  existing_global_cluster_identifier = module.primary_cluster.global_cluster_identifier
  is_secondary_cluster               = true

  # Security Configuration
  # For encrypted clusters, module automatically creates region-specific KMS key
  storage_encrypted   = var.storage_encrypted
  deletion_protection = var.deletion_protection

  # Backup Configuration (inherited from global cluster settings)
  backup_retention_period      = var.backup_retention_period
  preferred_backup_window      = var.secondary_preferred_backup_window
  preferred_maintenance_window = var.secondary_preferred_maintenance_window
  skip_final_snapshot          = var.skip_final_snapshot

  # Monitoring Configuration
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  tags = merge(
    module.tags.tags,
    {
      Name = local.secondary_cluster_identifier
      Role = "Secondary"
    }
  )

  # Ensure primary cluster conversion completes first
  depends_on = [module.primary_cluster]
}
