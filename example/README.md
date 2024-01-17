# terraform-aws-module-template example

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.67.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_example_doc_db_cluster"></a> [example\_doc\_db\_cluster](#module\_example\_doc\_db\_cluster) | ../ | n/a |
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.3 |

## Resources

| Name | Type |
|------|------|
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.vpc_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_size"></a> [cluster\_size](#input\_cluster\_size) | Number of instances to create in the cluster | `number` | `1` | no |
| <a name="input_doc_db_cluster_name"></a> [doc\_db\_cluster\_name](#input\_doc\_db\_cluster\_name) | Name of the DocumentDB cluster | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | environment value, e.g 'prod', 'staging', 'dev', 'UAT' | `string` | `"poc"` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | Instance class to use | `string` | `""` | no |
| <a name="input_master_username"></a> [master\_username](#input\_master\_username) | Username for the master DB user | `string` | `""` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for the resources. | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The project name | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_example_arn"></a> [example\_arn](#output\_example\_arn) | Amazon Resource Name (ARN) of the DocumentDB cluster |
| <a name="output_example_cluster_name"></a> [example\_cluster\_name](#output\_example\_cluster\_name) | DocumentDB Cluster Identifier |
| <a name="output_example_endpoint"></a> [example\_endpoint](#output\_example\_endpoint) | Endpoint of the DocumentDB cluster |
| <a name="output_example_reader_endpoint"></a> [example\_reader\_endpoint](#output\_example\_reader\_endpoint) | Read-only endpoint of the DocumentDB cluster, automatically load-balanced across replicas |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_example_doc_db_cluster"></a> [example\_doc\_db\_cluster](#module\_example\_doc\_db\_cluster) | ../documentdb_cluster | n/a |
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.3 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_cidr_blocks"></a> [allowed\_cidr\_blocks](#input\_allowed\_cidr\_blocks) | List of CIDR blocks to allow connections to the DocumentDB cluster | `list(string)` | `[]` | no |
| <a name="input_allowed_security_groups"></a> [allowed\_security\_groups](#input\_allowed\_security\_groups) | List of security groups to allow access to the cluster | `list(string)` | `[]` | no |
| <a name="input_cluster_size"></a> [cluster\_size](#input\_cluster\_size) | Number of instances to create in the cluster | `number` | `1` | no |
| <a name="input_doc_db_cluster_name"></a> [doc\_db\_cluster\_name](#input\_doc\_db\_cluster\_name) | Name of the DocumentDB cluster | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | environment value, e.g 'prod', 'staging', 'dev', 'UAT' | `string` | `"poc"` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | Instance class to use | `string` | `""` | no |
| <a name="input_master_password"></a> [master\_password](#input\_master\_password) | Password for the master DB user | `string` | `""` | no |
| <a name="input_master_username"></a> [master\_username](#input\_master\_username) | Username for the master DB user | `string` | `""` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for the resources. | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The project name | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | Route53 parent zone ID. If provided (not empty), the module will create sub-domain DNS records for the DocumentDB master and replicas | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
