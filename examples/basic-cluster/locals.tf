locals {
  security_group_data = {
    create      = true
    description = "Security Group for docdb instance"

    ingress_rules = [
      {
        description = "Allow traffic from local network"
        cidr_block  = data.aws_vpc.vpc.cidr_block
        from_port   = 27017
        ip_protocol = "tcp"
        to_port     = 27017
      }
    ]

    egress_rules = [
      {
        description = "Allow all outbound traffic"
        cidr_block  = "0.0.0.0/0"
        from_port   = -1
        ip_protocol = "-1"
        to_port     = -1
      }
    ]
  }
}
