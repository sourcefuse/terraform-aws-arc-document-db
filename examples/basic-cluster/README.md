# Basic DocumentDB Cluster Example

This example demonstrates how to create a minimal DocumentDB cluster with a single writer instance in an existing VPC.

## What This Example Creates

- DocumentDB cluster with 1 instance
- DB subnet group using provided subnet IDs
- Security group with ingress rules for specified CIDR blocks
- Basic backup and maintenance configuration

## Prerequisites

- Existing VPC with at least 2 subnets in different AZs
- Appropriate IAM permissions to create DocumentDB resources
- Terraform >= 1.3
- AWS Provider >= 5.0

## Usage

1. Copy the example tfvars file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit `terraform.tfvars` with your specific values:
   - Replace `subnet_ids` with your actual subnet IDs
   - Replace `vpc_id` with your VPC ID
   - Set a secure `master_password`
   - Adjust `allowed_cidr_blocks` as needed

3. Initialize and apply:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Variables Used

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_identifier | The cluster identifier | `string` | `"basic-docdb-cluster"` | no |
| master_username | Username for the master DB user | `string` | `"docdbadmin"` | no |
| master_password | Password for the master DB user | `string` | n/a | yes |
| instance_count | Number of instances in the cluster | `number` | `1` | no |
| instance_class | The instance class to use | `string` | `"db.t3.medium"` | no |
| subnet_ids | List of VPC subnet IDs | `list(string)` | n/a | yes |
| vpc_id | VPC ID where the security group will be created | `string` | n/a | yes |
| allowed_cidr_blocks | List of CIDR blocks allowed to access the DocumentDB cluster | `list(string)` | `["10.0.0.0/8"]` | no |

## Expected Outputs

- `cluster_endpoint`: Primary endpoint for write operations
- `cluster_reader_endpoint`: Read-only endpoint for read operations
- `cluster_id`: The DocumentDB cluster identifier
- `cluster_port`: Database port (27017)
- `instance_ids`: List of instance identifiers
- `security_group_id`: Security group ID for the cluster

## Security Considerations

- The master password is stored in Terraform state - consider using Secrets Manager in production
- Security group allows access from specified CIDR blocks only
- Encryption at rest is enabled by default using AWS managed keys
- Consider enabling deletion protection for production workloads

## Clean Up

```bash
terraform destroy
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_documentdb_cluster"></a> [documentdb\_cluster](#module\_documentdb\_cluster) | ../../ | n/a |
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.5 |

## Resources

| Name | Type |
|------|------|
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_cidr_blocks"></a> [allowed\_cidr\_blocks](#input\_allowed\_cidr\_blocks) | List of CIDR blocks allowed to access the DocumentDB cluster | `list(string)` | <pre>[<br/>  "10.0.0.0/8"<br/>]</pre> | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | The days to retain backups for | `number` | `7` | no |
| <a name="input_cluster_identifier"></a> [cluster\_identifier](#input\_cluster\_identifier) | The cluster identifier | `string` | `"basic-docdb-cluster"` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | A value that indicates whether the DB cluster has deletion protection enabled | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name | `string` | `"dev"` | no |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Additional tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | The instance class to use | `string` | `"db.t3.medium"` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of instances in the cluster | `number` | `1` | no |
| <a name="input_master_password"></a> [master\_password](#input\_master\_password) | Password for the master DB user | `string` | n/a | yes |
| <a name="input_master_username"></a> [master\_username](#input\_master\_username) | Username for the master DB user | `string` | `"docdbadmin"` | no |
| <a name="input_preferred_backup_window"></a> [preferred\_backup\_window](#input\_preferred\_backup\_window) | The daily time range during which automated backups are created | `string` | `"07:00-09:00"` | no |
| <a name="input_preferred_maintenance_window"></a> [preferred\_maintenance\_window](#input\_preferred\_maintenance\_window) | The weekly time range during which system maintenance can occur | `string` | `"sun:05:00-sun:06:00"` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name | `string` | `"basic-docdb"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs to associate with the DocumentDB cluster | `list(string)` | `[]` | no |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Skip final snapshot when destroying cluster | `bool` | `false` | no |
| <a name="input_storage_encrypted"></a> [storage\_encrypted](#input\_storage\_encrypted) | Specifies whether the DB cluster is encrypted | `bool` | `true` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of VPC subnet IDs (will be populated from data sources) | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource (legacy support) | `map(string)` | <pre>{<br/>  "Environment": "dev",<br/>  "Project": "basic-docdb"<br/>}</pre> | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID (will be populated from data sources) | `string` | `""` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the VPC to use | `string` | `"arc-poc-vpc"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | The DNS address of the DocumentDB instance |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The DocumentDB cluster identifier |
| <a name="output_cluster_port"></a> [cluster\_port](#output\_cluster\_port) | The database port |
| <a name="output_cluster_reader_endpoint"></a> [cluster\_reader\_endpoint](#output\_cluster\_reader\_endpoint) | A read-only endpoint for the DocumentDB cluster |
| <a name="output_instance_ids"></a> [instance\_ids](#output\_instance\_ids) | List of DocumentDB instance identifiers |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the security group created for the DocumentDB cluster |
<!-- END_TF_DOCS -->
