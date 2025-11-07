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
  master_password    = var.master_password

  instance_count = var.instance_count
  instance_class = var.instance_class

  subnet_config = {
    subnet_ids = data.aws_subnets.private.ids
  }
  vpc_id = data.aws_vpc.vpc.id

  # Use simple security group IDs
  security_group_ids = var.security_group_ids

  backup_retention_period      = var.backup_retention_period
  preferred_backup_window      = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window
  skip_final_snapshot          = var.skip_final_snapshot

  storage_encrypted   = var.storage_encrypted
  deletion_protection = var.deletion_protection

  tags = module.tags.tags
}
