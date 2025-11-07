################################################################################
## VPC and Subnet Lookups
################################################################################

data "aws_vpc" "main" {
  filter {
    name   = "cidr-block"
    values = ["10.12.0.0/16"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

  filter {
    name   = "availability-zone"
    values = ["us-east-1a", "us-east-1b"]
  }
}
