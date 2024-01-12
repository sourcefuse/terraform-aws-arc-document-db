################################################################################
## defaults
################################################################################
terraform {
  required_version = "~> 1.3, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

module "tags" {
  source      = "sourcefuse/arc-tags/aws"
  version     = "1.2.3"
  environment = var.environment
  project     = var.project_name

  extra_tags = {
    MonoRepo     = "True"
    MonoRepoPath = "terraform/doc_db_cluster"
  }
}

provider "aws" {
  region = var.region
}

module "example_doc_db_cluster" {
  source = "../" // TODO - update this

  namespace   = var.namespace
  environment = var.environment

  doc_db_cluster_name = var.doc_db_cluster_name
  cluster_size        = var.cluster_size
  master_username     = var.master_username
  instance_class      = var.instance_class
  vpc_id              = data.aws_vpc.vpc_id.id
  subnet_ids          = data.aws_subnets.private.ids

  tags = module.tags.tags

}
