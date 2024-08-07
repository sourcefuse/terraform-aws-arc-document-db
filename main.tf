################################################################################
## defaults
################################################################################
terraform {
  required_version = "~> 1.3, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0, < 6.0"
    }
  }
}

module "doc_db_cluster" {
  source                          = "cloudposse/documentdb-cluster/aws"
  version                         = "0.24.0"
  namespace                       = var.namespace
  environment                     = var.environment
  name                            = var.doc_db_cluster_name
  cluster_size                    = var.cluster_size
  master_username                 = var.master_username
  instance_class                  = var.instance_class
  db_port                         = var.db_port
  vpc_id                          = var.vpc_id
  subnet_ids                      = var.subnet_ids
  zone_id                         = var.zone_id
  apply_immediately               = var.apply_immediately
  auto_minor_version_upgrade      = var.auto_minor_version_upgrade
  allowed_security_groups         = var.allowed_security_groups
  allowed_cidr_blocks             = var.allowed_cidr_blocks
  snapshot_identifier             = var.snapshot_identifier
  retention_period                = var.retention_period
  preferred_backup_window         = var.preferred_backup_window
  preferred_maintenance_window    = var.preferred_maintenance_window
  cluster_parameters              = var.cluster_parameters
  cluster_family                  = var.cluster_family
  engine                          = var.engine
  engine_version                  = var.engine_version
  storage_encrypted               = var.storage_encrypted
  kms_key_id                      = var.kms_key_id
  skip_final_snapshot             = var.skip_final_snapshot
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  cluster_dns_name                = var.cluster_dns_name
  reader_dns_name                 = var.reader_dns_name
  ssm_parameter_enabled           = var.ssm_parameter_enabled
  ssm_parameter_path_prefix       = var.ssm_parameter_path_prefix
  tags                            = var.tags
}

////////////////  SSM VALUES ////////////////////////////////////////

resource "aws_ssm_parameter" "documentdb_host" {
  name  = var.documentdb_host
  type  = "String"
  value = module.doc_db_cluster.endpoint
}

resource "aws_ssm_parameter" "documentdb_port" {
  name  = var.documentdb_port
  type  = "String"
  value = var.db_port
}

resource "aws_ssm_parameter" "documentdb_username" {
  name  = var.documentdb_username
  type  = "String"
  value = module.doc_db_cluster.master_username
}
