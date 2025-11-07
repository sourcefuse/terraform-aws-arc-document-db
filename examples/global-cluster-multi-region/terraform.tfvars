global_cluster_identifier = "global-docdb-cluster"

primary_region   = "us-east-1"
secondary_region = "us-east-2"

primary_cluster_identifier   = "primary-docdb-cluster"
secondary_cluster_identifier = "secondary-docdb-cluster"

master_username = "docdbadmin"

# Secrets Manager configuration
secret_recovery_window_in_days = 7 # Minimum allowed value

primary_instance_count   = 1
secondary_instance_count = 1

primary_instance_class   = "db.r5.large"
secondary_instance_class = "db.r5.large"

# Use existing VPC
primary_vpc_name   = "arc-poc-vpc"
secondary_vpc_name = "sf-dev-vpc"

# Security group rules for SourceFuse module format
primary_ingress_rules = [
  {
    description = "DocumentDB access from VPC"
    from_port   = 27017
    to_port     = 27017
    ip_protocol = "tcp"
    cidr_block  = "10.12.0.0/16"
  }
]

secondary_ingress_rules = [
  {
    description = "DocumentDB access from VPC"
    from_port   = 27017
    to_port     = 27017
    ip_protocol = "tcp"
    cidr_block  = "172.31.0.0/16"
  }
]

backup_retention_period = 7
deletion_protection     = false
skip_final_snapshot     = true

enabled_cloudwatch_logs_exports = ["audit"]

# Tags module configuration
environment = "dev"
project     = "global-docdb"
