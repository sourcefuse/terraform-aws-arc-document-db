################################################################################
## Primary Region Lookups
################################################################################
data "aws_vpc" "primary" {
  provider = aws.primary
  filter {
    name   = "tag:Name"
    values = [var.primary_vpc_name]
  }
}

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

################################################################################
## Secondary Region Lookups
################################################################################

data "aws_vpc" "secondary" {
  provider = aws.secondary
  filter {
    name   = "tag:Name"
    values = [var.secondary_vpc_name]
  }
}

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
