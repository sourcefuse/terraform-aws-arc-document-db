global_cluster_identifier = "global-docdb-cluster"

primary_region   = "us-east-1"
secondary_region = "us-east-2"

primary_cluster_identifier   = "primary-docdb-cluster"
secondary_cluster_identifier = "secondary-docdb-cluster"

master_username = "docdbadmin"

primary_instance_count   = 1
secondary_instance_count = 1

primary_instance_class   = "db.r5.large"
secondary_instance_class = "db.r5.large"

# Use existing VPC
primary_vpc_name = "arc-poc-vpc"

backup_retention_period = 7
deletion_protection     = false
skip_final_snapshot     = true

enabled_cloudwatch_logs_exports = ["audit"]

# Tags module configuration
environment = "dev"
project     = "global-docdb"
