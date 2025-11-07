cluster_identifier = "multi-az-docdb-cluster"
master_username    = "docdbadmin"

# Use 3 instances across multiple AZs
instance_count = 3
instance_class = "db.r5.large"

# Allow access from VPC CIDR
allowed_cidr_blocks = ["10.12.0.0/16"]

# Secrets Manager configuration
# secret_name will be auto-generated as "${cluster_identifier}-credentials-${random_suffix}"
secret_recovery_window_in_days = 7 # Minimum allowed value

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
environment = "arc"
project     = "multi-az-docdb"

extra_tags = {
  Purpose = "multi-az-testing"
  Owner   = "terraform"
}
