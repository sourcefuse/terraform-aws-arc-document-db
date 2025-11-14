# DocumentDB Global Cluster Multi-Region Example

This example demonstrates how to create a DocumentDB Global Cluster with primary and secondary clusters across multiple AWS regions for disaster recovery and high availability.

## What This Example Creates

- **Global Cluster**: DocumentDB Global Cluster spanning multiple regions
- **Primary Cluster**: Full-featured cluster in primary region (us-east-1) with:
  - 2 instances for high availability
  - Secrets Manager integration
  - Customer-managed KMS key
  - CloudWatch logs exports
- **Secondary Cluster**: Read-only cluster in secondary region (us-west-2) with:
  - 1 instance (can be scaled up)
  - Inherits encryption from global cluster
  - Independent VPC and security configuration


## Prerequisites

- **Multi-Region Setup**: VPCs and subnets in both primary and secondary regions
- **Cross-Region Permissions**: IAM permissions for both regions
- **Network Connectivity**: Ensure proper routing between regions if needed
- **Terraform**: >= 1.3
- **AWS Provider**: >= 5.0

## Key Features

### Global Cluster Benefits
- **Cross-Region Replication**: Automatic data replication to secondary region
- **Disaster Recovery**: Fast failover capability (typically < 1 minute)
- **Read Scaling**: Distribute read workloads across regions
- **Low Latency**: Serve users from the nearest region

## Usage

1. **Set up VPCs in both regions**:
   ```bash
   # Ensure you have VPCs and subnets in both us-east-1 and us-west-2
   ```

2. **Copy and configure variables**:
   ```bash
    terraform.tfvars
   # Edit terraform.tfvars with your actual VPC/subnet IDs
   ```

3. **Deploy the global cluster**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Security Considerations

- **Encryption**: Both clusters use encryption at rest
- **Network Isolation**: Each cluster in its own VPC
- **Access Control**: Independent security groups per region
- **Credential Management**: Secrets Manager in primary region only


## Troubleshooting

### Common Issues
1. **Cross-region permissions**: Ensure IAM roles have permissions in both regions
2. **VPC connectivity**: Verify subnets and security groups in both regions
3. **Replication lag**: Monitor CloudWatch metrics for replication health


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_primary_cluster"></a> [primary\_cluster](#module\_primary\_cluster) | ../../ | n/a |
| <a name="module_secondary_cluster"></a> [secondary\_cluster](#module\_secondary\_cluster) | ../../ | n/a |
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.5 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | The days to retain backups for | `number` | `30` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | A value that indicates whether the clusters have deletion protection enabled | `bool` | `true` | no |
| <a name="input_egress_rules"></a> [egress\_rules](#input\_egress\_rules) | List of egress rules for the security groups | <pre>list(object({<br/>    description                   = optional(string, null)<br/>    cidr_block                    = optional(string, null)<br/>    destination_security_group_id = optional(string, null)<br/>    from_port                     = number<br/>    ip_protocol                   = string<br/>    to_port                       = string<br/>    prefix_list_id                = optional(string, null)<br/>  }))</pre> | <pre>[<br/>  {<br/>    "cidr_block": "0.0.0.0/0",<br/>    "description": "All outbound traffic",<br/>    "from_port": -1,<br/>    "ip_protocol": "-1",<br/>    "to_port": "-1"<br/>  }<br/>]</pre> | no |
| <a name="input_enabled_cloudwatch_logs_exports"></a> [enabled\_cloudwatch\_logs\_exports](#input\_enabled\_cloudwatch\_logs\_exports) | List of log types to export to cloudwatch | `list(string)` | <pre>[<br/>  "audit",<br/>  "profiler"<br/>]</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name | `string` | `"prod"` | no |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Additional tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_global_cluster_identifier"></a> [global\_cluster\_identifier](#input\_global\_cluster\_identifier) | The global cluster identifier | `string` | `"global-docdb-cluster"` | no |
| <a name="input_master_username"></a> [master\_username](#input\_master\_username) | Username for the master DB user | `string` | `"docdbadmin"` | no |
| <a name="input_primary_cluster_identifier"></a> [primary\_cluster\_identifier](#input\_primary\_cluster\_identifier) | The primary cluster identifier | `string` | `"primary-docdb-cluster"` | no |
| <a name="input_primary_ingress_rules"></a> [primary\_ingress\_rules](#input\_primary\_ingress\_rules) | List of ingress rules for the primary cluster security group | <pre>list(object({<br/>    description = optional(string, null)<br/>    cidr_block  = optional(string, null)<br/>    from_port   = number<br/>    ip_protocol = string<br/>    to_port     = string<br/>    self        = optional(bool, false)<br/>  }))</pre> | `[]` | no |
| <a name="input_primary_instance_class"></a> [primary\_instance\_class](#input\_primary\_instance\_class) | The instance class for primary cluster | `string` | `"db.r5.large"` | no |
| <a name="input_primary_instance_count"></a> [primary\_instance\_count](#input\_primary\_instance\_count) | Number of instances in the primary cluster | `number` | `2` | no |
| <a name="input_primary_region"></a> [primary\_region](#input\_primary\_region) | Primary region for the global cluster | `string` | `"us-east-1"` | no |
| <a name="input_primary_subnet_ids"></a> [primary\_subnet\_ids](#input\_primary\_subnet\_ids) | List of VPC subnet IDs in primary region | `list(string)` | n/a | yes |
| <a name="input_primary_vpc_id"></a> [primary\_vpc\_id](#input\_primary\_vpc\_id) | VPC ID in primary region | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project name | `string` | `"global-docdb"` | no |
| <a name="input_secondary_cluster_identifier"></a> [secondary\_cluster\_identifier](#input\_secondary\_cluster\_identifier) | The secondary cluster identifier | `string` | `"secondary-docdb-cluster"` | no |
| <a name="input_secondary_ingress_rules"></a> [secondary\_ingress\_rules](#input\_secondary\_ingress\_rules) | List of ingress rules for the secondary cluster security group | <pre>list(object({<br/>    description = optional(string, null)<br/>    cidr_block  = optional(string, null)<br/>    from_port   = number<br/>    ip_protocol = string<br/>    to_port     = string<br/>    self        = optional(bool, false)<br/>  }))</pre> | `[]` | no |
| <a name="input_secondary_instance_class"></a> [secondary\_instance\_class](#input\_secondary\_instance\_class) | The instance class for secondary cluster | `string` | `"db.r5.large"` | no |
| <a name="input_secondary_instance_count"></a> [secondary\_instance\_count](#input\_secondary\_instance\_count) | Number of instances in the secondary cluster | `number` | `1` | no |
| <a name="input_secondary_region"></a> [secondary\_region](#input\_secondary\_region) | Secondary region for the global cluster | `string` | `"us-west-2"` | no |
| <a name="input_secondary_subnet_ids"></a> [secondary\_subnet\_ids](#input\_secondary\_subnet\_ids) | List of VPC subnet IDs in secondary region | `list(string)` | n/a | yes |
| <a name="input_secondary_vpc_id"></a> [secondary\_vpc\_id](#input\_secondary\_vpc\_id) | VPC ID in secondary region | `string` | n/a | yes |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Skip final snapshot when destroying clusters | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources (legacy support) | `map(string)` | <pre>{<br/>  "Environment": "prod",<br/>  "Project": "global-docdb",<br/>  "Purpose": "multi-region-dr"<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connection_info"></a> [connection\_info](#output\_connection\_info) | Connection information for both clusters |
| <a name="output_global_cluster_arn"></a> [global\_cluster\_arn](#output\_global\_cluster\_arn) | Amazon Resource Name (ARN) of the global cluster |
| <a name="output_global_cluster_identifier"></a> [global\_cluster\_identifier](#output\_global\_cluster\_identifier) | The DocumentDB global cluster identifier |
| <a name="output_global_cluster_members"></a> [global\_cluster\_members](#output\_global\_cluster\_members) | List of DocumentDB Clusters that are part of this global cluster |
| <a name="output_primary_cluster_endpoint"></a> [primary\_cluster\_endpoint](#output\_primary\_cluster\_endpoint) | The DNS address of the primary DocumentDB cluster |
| <a name="output_primary_cluster_id"></a> [primary\_cluster\_id](#output\_primary\_cluster\_id) | The primary DocumentDB cluster identifier |
| <a name="output_primary_cluster_reader_endpoint"></a> [primary\_cluster\_reader\_endpoint](#output\_primary\_cluster\_reader\_endpoint) | A read-only endpoint for the primary DocumentDB cluster |
| <a name="output_primary_secret_arn"></a> [primary\_secret\_arn](#output\_primary\_secret\_arn) | The ARN of the secret containing primary cluster credentials |
| <a name="output_secondary_cluster_endpoint"></a> [secondary\_cluster\_endpoint](#output\_secondary\_cluster\_endpoint) | The DNS address of the secondary DocumentDB cluster |
| <a name="output_secondary_cluster_id"></a> [secondary\_cluster\_id](#output\_secondary\_cluster\_id) | The secondary DocumentDB cluster identifier |
| <a name="output_secondary_cluster_reader_endpoint"></a> [secondary\_cluster\_reader\_endpoint](#output\_secondary\_cluster\_reader\_endpoint) | A read-only endpoint for the secondary DocumentDB cluster |
<!-- END_TF_DOCS -->
