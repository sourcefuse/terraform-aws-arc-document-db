# =============================================================================
# EXAMPLE TERRAFORM VARIABLES FOR GLOBAL CLUSTER CONVERSION
# =============================================================================
# Copy this file to terraform.tfvars and update the values to match your
# existing DocumentDB cluster and desired configuration.

# =============================================================================
# PROJECT INFORMATION
# =============================================================================
project_name = "my-docdb-project"
environment  = "prod" # Environment of your existing cluster
# Use existing VPC
primary_vpc_name = "arc-poc-vpc"
# =============================================================================
# REGION CONFIGURATION
# =============================================================================
primary_region   = "us-east-1" # Region where your existing cluster is located
secondary_region = "us-west-2" # Region for your disaster recovery cluster

# =============================================================================
# EXISTING CLUSTER INFORMATION (MUST MATCH CURRENT CLUSTER)
# =============================================================================
primary_cluster_identifier = "my-existing-cluster"     # Your existing cluster name
master_username            = "docdbadmin"              # Current master username
master_password            = "YourCurrentPassword123!" # Current master password

# Engine version must match your existing cluster
engine_version = "4.0.0" # Check your cluster's current version

# =============================================================================
# GLOBAL CLUSTER CONFIGURATION
# =============================================================================
global_cluster_identifier = "my-global-cluster"

# =============================================================================
# SECONDARY CLUSTER CONFIGURATION
# =============================================================================
secondary_cluster_identifier = "my-existing-cluster-dr" # Name for DR cluster

# Instance configuration for secondary cluster
secondary_instance_count = 1 # Start with 1 for cost optimization
secondary_instance_class = "db.t3.medium"



# CIDR blocks allowed to access DocumentDB
allowed_cidr_blocks = [
  "10.0.0.0/16",  # Your VPC CIDR
  "172.16.0.0/16" # Additional allowed networks
]

# =============================================================================
# INSTANCE CONFIGURATION
# =============================================================================
primary_instance_count = 2
primary_instance_class = "db.t3.medium"

# =============================================================================
# SECURITY CONFIGURATION
# =============================================================================
storage_encrypted   = true
deletion_protection = true

# =============================================================================
# BACKUP CONFIGURATION
# =============================================================================
backup_retention_period      = 7
preferred_backup_window      = "07:00-09:00"
preferred_maintenance_window = "sun:05:00-sun:06:00"

# Different backup/maintenance windows for secondary to avoid conflicts
secondary_preferred_backup_window      = "10:00-12:00"
secondary_preferred_maintenance_window = "sun:08:00-sun:09:00"

skip_final_snapshot = false

# =============================================================================
# MONITORING CONFIGURATION
# =============================================================================
enabled_cloudwatch_logs_exports = ["audit", "profiler"]

# =============================================================================
# PARAMETER GROUP CONFIGURATION
# =============================================================================
parameter_group_config = {
  create = true
  family = "docdb4.0" # Must match your engine version
  parameters = [
    {
      name  = "tls"
      value = "enabled"
    }
    # Add any other parameters your existing cluster uses
  ]
}

# =============================================================================
# MIGRATION CHECKLIST
# =============================================================================
# Before running terraform apply, ensure:
#
# 1. All values above match your existing cluster configuration
# 2. You have verified the master_username and master_password
# 3. The engine_version matches your existing cluster exactly
# 4. VPC and subnet configurations are correct for both regions
# 5. You have tested connectivity to both regions
# 6. You have appropriate AWS permissions in both regions
# 7. You have created a backup of your existing cluster (recommended)
#
# IMPORTANT NOTES:
# - This conversion does NOT cause downtime to your existing cluster
# - The existing cluster becomes the PRIMARY of the global cluster
# - Data is replicated to the secondary region automatically
# - You can fail over between regions if needed for DR scenarios
# =============================================================================
