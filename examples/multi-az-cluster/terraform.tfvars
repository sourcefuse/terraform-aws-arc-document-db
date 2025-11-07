cluster_identifier = "multi-az-docdb-cluster"
master_username    = "docdbadmin"

# Use 3 instances across multiple AZs
instance_count = 3
instance_class = "db.r5.large"

# Use existing VPC and subnets from us-east-1
vpc_id = "vpc-0e6c09980580ecbf6"
subnet_ids = [
  "subnet-064b80a494fed9835",
  "subnet-066d0c78479b72e77"
]

# Allow access from VPC CIDR
allowed_cidr_blocks = ["10.12.0.0/16"]

# Secrets Manager configuration
secret_name                    = "multi-az-docdb-credentials-v2"
secret_recovery_window_in_days = 7

# KMS configuration
kms_key_description = "DocumentDB cluster encryption key for multi-AZ cluster"

# Backup configuration
backup_retention_period      = 7
preferred_backup_window      = "03:00-05:00"
preferred_maintenance_window = "sun:02:00-sun:03:00"

# Disable deletion protection for easier cleanup
deletion_protection = false

# CloudWatch logs
enabled_cloudwatch_logs_exports = ["audit", "profiler"]

# Parameter group configuration
db_cluster_parameter_group_family = "docdb4.0"
db_cluster_parameter_group_parameters = [
  {
    name  = "tls"
    value = "enabled"
  },
  {
    name  = "audit_logs"
    value = "enabled"
  },
  {
    name  = "profiler"
    value = "enabled"
  },
  {
    name  = "profiler_threshold_ms"
    value = "100"
  }
]

# Tags
environment = "dev"
project     = "multi-az-docdb"

extra_tags = {
  Purpose = "multi-az-testing"
  Owner   = "terraform"
}
