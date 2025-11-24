# =============================================================================
# LOCAL VALUES
# =============================================================================
# These local values compute configurations that are reused throughout the module

locals {
  # ==========================================================================
  # COMPUTED IDENTIFIERS
  # ==========================================================================

  # Use provided secondary cluster identifier or generate one
  secondary_cluster_identifier = var.secondary_cluster_identifier != null ? var.secondary_cluster_identifier : "${var.primary_cluster_identifier}-secondary"

  # Use provided global cluster identifier or generate one
  global_cluster_identifier = var.global_cluster_identifier != null ? var.global_cluster_identifier : "${var.primary_cluster_identifier}-global"

  # ==========================================================================
  # SUBNET SELECTION
  # ==========================================================================

  # Use private subnets if available, otherwise fall back to all subnets
  primary_subnet_ids = length(data.aws_subnets.primary_private.ids) > 0 ? data.aws_subnets.primary_private.ids : data.aws_subnets.primary_all.ids

  secondary_subnet_ids = length(data.aws_subnets.secondary_private.ids) > 0 ? data.aws_subnets.secondary_private.ids : data.aws_subnets.secondary_all.ids

  # ==========================================================================
  # SECURITY GROUP CONFIGURATIONS
  # ==========================================================================

  # Primary cluster security group configuration
  primary_security_group_data = {
    create      = true
    description = "Security group for primary DocumentDB cluster"
    ingress_rules = [
      {
        description = "DocumentDB access from VPC"
        from_port   = 27017
        to_port     = 27017
        ip_protocol = "tcp"
        cidr_block  = data.aws_vpc.primary.cidr_block
      },
      {
        description = "DocumentDB access from allowed networks"
        from_port   = 27017
        to_port     = 27017
        ip_protocol = "tcp"
        cidr_block  = join(",", var.allowed_cidr_blocks)
      }
    ]
    egress_rules = [
      {
        description = "All outbound traffic"
        from_port   = 0
        to_port     = 0
        ip_protocol = "-1"
        cidr_block  = "0.0.0.0/0"
      }
    ]
  }

  # Secondary cluster security group configuration
  secondary_security_group_data = {
    create      = true
    description = "Security group for secondary DocumentDB cluster"
    ingress_rules = [
      {
        description = "DocumentDB access from VPC"
        from_port   = 27017
        to_port     = 27017
        ip_protocol = "tcp"
        cidr_block  = data.aws_vpc.secondary.cidr_block
      },
      {
        description = "DocumentDB access from allowed networks"
        from_port   = 27017
        to_port     = 27017
        ip_protocol = "tcp"
        cidr_block  = join(",", var.allowed_cidr_blocks)
      }
    ]
    egress_rules = [
      {
        description = "All outbound traffic"
        from_port   = 0
        to_port     = 27017
        ip_protocol = "tcp"
        cidr_block  = "0.0.0.0/0"
      }
    ]
  }

}
