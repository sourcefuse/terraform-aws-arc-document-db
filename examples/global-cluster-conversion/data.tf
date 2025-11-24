# =============================================================================
# DATA SOURCES
# =============================================================================
# These data sources retrieve information about existing AWS infrastructure
# that will be used by the DocumentDB clusters.

# =============================================================================
# PRIMARY REGION DATA SOURCES
# =============================================================================

# Get VPC information in primary region
data "aws_vpc" "primary" {
  provider = aws.primary

  filter {
    name   = "tag:Name"
    values = [var.primary_vpc_name]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# Get private subnets in primary region
data "aws_subnets" "primary_private" {
  provider = aws.primary

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.primary.id]
  }

  filter {
    name   = "tag:Type"
    values = ["private"]
  }
}

# Fallback: Get all subnets if no private subnets tagged
data "aws_subnets" "primary_all" {
  provider = aws.primary

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.primary.id]
  }
}


# =============================================================================
# SECONDARY REGION DATA SOURCES
# =============================================================================

# Get VPC information in secondary region
data "aws_vpc" "secondary" {
  provider = aws.secondary

  filter {
    name   = "tag:Name"
    values = [var.secondary_vpc_name]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# Get private subnets in secondary region
data "aws_subnets" "secondary_private" {
  provider = aws.secondary

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.secondary.id]
  }

  filter {
    name   = "tag:Type"
    values = ["private"]
  }
}

# Fallback: Get all subnets if no private subnets tagged
data "aws_subnets" "secondary_all" {
  provider = aws.secondary

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.secondary.id]
  }
}
