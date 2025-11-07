# Multi-AZ DocumentDB Cluster Example

This example demonstrates how to create a highly available DocumentDB cluster with multiple instances across different Availability Zones, enhanced monitoring, custom parameter groups, and production-ready security configurations.

## What This Example Creates

- DocumentDB cluster with 3 instances distributed across multiple AZs
- AWS Secrets Manager secret with auto-generated master password
- Customer-managed KMS key for encryption at rest and secrets encryption
- Custom DB cluster parameter group with TLS enforcement and audit logging
- DB subnet group spanning multiple AZs
- Security group with flexible access control (CIDR blocks and/or security groups)
- CloudWatch logs exports for audit and profiler logs
- Enhanced backup configuration with 30-day retention
- Deletion protection enabled for production safety

## Prerequisites

- Existing VPC with at least 3 subnets in different AZs for true multi-AZ deployment
- Appropriate IAM permissions to create DocumentDB, Secrets Manager, and KMS resources
- Terraform >= 1.3
- AWS Provider >= 5.0


## Usage

1. Copy the example tfvars file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit `terraform.tfvars` with your specific values:
   - Replace `subnet_ids` with your actual subnet IDs across different AZs
   - Replace `vpc_id` with your VPC ID
   - Replace `allowed_security_group_ids` with your application security groups
   - Customize instance class and count based on your performance requirements
   - Adjust backup retention and maintenance windows for your needs

3. Initialize and apply:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## High Availability Features

- **Multi-AZ Deployment**: Instances distributed across multiple Availability Zones
- **Automatic Failover**: Primary instance failure triggers automatic failover to a reader
- **Read Scaling**: Multiple reader instances for read workload distribution
- **Enhanced Backup**: 30-day backup retention with point-in-time recovery
- **Monitoring**: CloudWatch logs for audit trails and performance profiling

## Security Features

- **TLS Enforcement**: All connections must use TLS encryption
- **Audit Logging**: All database operations are logged
- **Customer-Managed Encryption**: Both data and secrets encrypted with your KMS key
- **Network Isolation**: Access controlled via security groups
- **Secrets Management**: Credentials stored securely in AWS Secrets Manager
- **Deletion Protection**: Prevents accidental cluster deletion



<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_documentdb_cluster"></a> [documentdb\_cluster](#module\_documentdb\_cluster) | ../../ | n/a |
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.5 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_cidr_blocks"></a> [allowed\_cidr\_blocks](#input\_allowed\_cidr\_blocks) | List of CIDR blocks allowed to access the DocumentDB cluster | `list(string)` | `[]` | no |
| <a name="input_allowed_security_group_ids"></a> [allowed\_security\_group\_ids](#input\_allowed\_security\_group\_ids) | List of security group IDs allowed to access the DocumentDB cluster | `list(string)` | `[]` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | The days to retain backups for | `number` | `30` | no |
| <a name="input_cluster_identifier"></a> [cluster\_identifier](#input\_cluster\_identifier) | The cluster identifier | `string` | `"multi-az-docdb-cluster"` | no |
| <a name="input_db_cluster_parameter_group_family"></a> [db\_cluster\_parameter\_group\_family](#input\_db\_cluster\_parameter\_group\_family) | The DB cluster parameter group family | `string` | `"docdb4.0"` | no |
| <a name="input_db_cluster_parameter_group_parameters"></a> [db\_cluster\_parameter\_group\_parameters](#input\_db\_cluster\_parameter\_group\_parameters) | A list of DB cluster parameters to apply | <pre>list(object({<br/>    name  = string<br/>    value = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "name": "tls",<br/>    "value": "enabled"<br/>  },<br/>  {<br/>    "name": "audit_logs",<br/>    "value": "enabled"<br/>  },<br/>  {<br/>    "name": "profiler",<br/>    "value": "enabled"<br/>  },<br/>  {<br/>    "name": "profiler_threshold_ms",<br/>    "value": "100"<br/>  }<br/>]</pre> | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | A value that indicates whether the DB cluster has deletion protection enabled | `bool` | `true` | no |
| <a name="input_enabled_cloudwatch_logs_exports"></a> [enabled\_cloudwatch\_logs\_exports](#input\_enabled\_cloudwatch\_logs\_exports) | List of log types to export to cloudwatch | `list(string)` | <pre>[<br/>  "audit",<br/>  "profiler"<br/>]</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name | `string` | `"prod"` | no |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Additional tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | The instance class to use | `string` | `"db.r5.large"` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of instances in the cluster | `number` | `3` | no |
| <a name="input_kms_key_description"></a> [kms\_key\_description](#input\_kms\_key\_description) | Description for the KMS key | `string` | `"DocumentDB cluster encryption key for multi-AZ cluster"` | no |
| <a name="input_master_username"></a> [master\_username](#input\_master\_username) | Username for the master DB user | `string` | `"docdbadmin"` | no |
| <a name="input_preferred_backup_window"></a> [preferred\_backup\_window](#input\_preferred\_backup\_window) | The daily time range during which automated backups are created | `string` | `"03:00-05:00"` | no |
| <a name="input_preferred_maintenance_window"></a> [preferred\_maintenance\_window](#input\_preferred\_maintenance\_window) | The weekly time range during which system maintenance can occur | `string` | `"sun:02:00-sun:03:00"` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name | `string` | `"multi-az-docdb"` | no |
| <a name="input_secret_name"></a> [secret\_name](#input\_secret\_name) | Name for the Secrets Manager secret | `string` | `"multi-az-docdb-credentials"` | no |
| <a name="input_secret_recovery_window_in_days"></a> [secret\_recovery\_window\_in\_days](#input\_secret\_recovery\_window\_in\_days) | Number of days that AWS Secrets Manager waits before it can delete the secret | `number` | `30` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of VPC subnet IDs across multiple AZs | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource (legacy support) | `map(string)` | <pre>{<br/>  "Environment": "prod",<br/>  "Project": "multi-az-docdb",<br/>  "Tier": "database"<br/>}</pre> | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID where the security group will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | Amazon Resource Name (ARN) of the cluster |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | The DNS address of the DocumentDB instance |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The DocumentDB cluster identifier |
| <a name="output_cluster_members"></a> [cluster\_members](#output\_cluster\_members) | List of DocumentDB Instances that are a part of this cluster |
| <a name="output_cluster_port"></a> [cluster\_port](#output\_cluster\_port) | The database port |
| <a name="output_cluster_reader_endpoint"></a> [cluster\_reader\_endpoint](#output\_cluster\_reader\_endpoint) | A read-only endpoint for the DocumentDB cluster |
| <a name="output_db_cluster_parameter_group_name"></a> [db\_cluster\_parameter\_group\_name](#output\_db\_cluster\_parameter\_group\_name) | The name of the DB cluster parameter group |
| <a name="output_instance_endpoints"></a> [instance\_endpoints](#output\_instance\_endpoints) | List of DocumentDB instance endpoints |
| <a name="output_instance_ids"></a> [instance\_ids](#output\_instance\_ids) | List of DocumentDB instance identifiers |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | The Amazon Resource Name (ARN) of the KMS key |
| <a name="output_master_username"></a> [master\_username](#output\_master\_username) | The master username for the DB cluster |
| <a name="output_secret_arn"></a> [secret\_arn](#output\_secret\_arn) | The ARN of the secret containing master credentials |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the security group created for the DocumentDB cluster |
<!-- END_TF_DOCS -->
