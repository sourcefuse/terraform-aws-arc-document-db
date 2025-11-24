# =============================================================================
# MULTI-REGION PROVIDER CONFIGURATION
# =============================================================================
# Global clusters require resources in multiple AWS regions. This configuration
# sets up providers for both the primary region (where your existing cluster is)
# and the secondary region (where the DR cluster will be created).

terraform {
  required_version = "~> 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0, < 7.0"
    }
  }
}

# Primary Region Provider
# This is where your existing DocumentDB cluster is located
provider "aws" {
  alias  = "primary"
  region = var.primary_region

  # Optional: Add assume role configuration if needed
  # assume_role {
  #   role_arn = var.primary_role_arn
  # }

  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Project   = var.project_name
      Example   = "global-cluster-conversion"
    }
  }
}

# Secondary Region Provider
# This is where your new DR cluster will be created
provider "aws" {
  alias  = "secondary"
  region = var.secondary_region

  # Optional: Add assume role configuration if needed
  # assume_role {
  #   role_arn = var.secondary_role_arn
  # }

  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Project   = var.project_name
      Example   = "global-cluster-conversion"
    }
  }
}
