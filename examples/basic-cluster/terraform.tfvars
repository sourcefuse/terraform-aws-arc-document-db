cluster_identifier = "basic-docdb-cluster"
master_username    = "docdbadmin"
master_password    = "SecurePassword123!"

vpc_name = "arc-poc-vpc"

instance_count = 1
instance_class = "db.t3.medium"


backup_retention_period      = 7
preferred_backup_window      = "07:00-09:00"
preferred_maintenance_window = "sun:05:00-sun:06:00"

storage_encrypted   = true
deletion_protection = false
skip_final_snapshot = true

# Tags module configuration
environment = "dev"
project     = "basic-docdb"

extra_tags = {
  Owner = "terraform"
  Team  = "platform"
}
