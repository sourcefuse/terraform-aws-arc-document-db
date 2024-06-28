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

module "tags" {
  source      = "sourcefuse/arc-tags/aws"
  version     = "1.2.3"
  environment = var.environment
  project     = var.project_name

}

provider "aws" {
  region = var.region
}

module "doc_db_cluster" {
  source = "sourcefuse/arc-document-db/aws"
  // we recommend to pin the version we aren't simply for an example reference against our latest changes.
  namespace           = var.namespace
  environment         = var.environment
  doc_db_cluster_name = var.doc_db_cluster_name
  cluster_size        = var.cluster_size
  master_username     = var.master_username
  instance_class      = var.instance_class
  vpc_id              = data.aws_vpc.vpc_id.id
  subnet_ids          = data.aws_subnets.private.ids
  tags                = module.tags.tags
}
