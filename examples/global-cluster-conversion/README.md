# Global Cluster Conversion Example

This example demonstrates how to **convert an existing Multi-AZ DocumentDB cluster** to a global cluster with cross-region replication for disaster recovery.

## Overview

This is a **conversion scenario** where you have:
- An existing DocumentDB cluster managed by Terraform
- Need to add disaster recovery capabilities
- Want to maintain zero downtime during the conversion
- Need cross-region replication for business continuity

## What This Example Does

1. **Converts** your existing DocumentDB cluster to become the **PRIMARY** of a global cluster
2. **Creates** a new **SECONDARY** cluster in a different AWS region for disaster recovery
3. **Establishes** automatic cross-region replication between the clusters
4. **Maintains** zero downtime - your existing cluster continues operating normally
5. **Preserves** all existing data and configurations

## Prerequisites

Before running this example, ensure you have:

### Existing Infrastructure
- [x] An existing DocumentDB cluster managed by Terraform
- [x] VPCs and subnets configured in both primary and secondary regions
- [x] Appropriate security groups or network ACLs
- [x] AWS credentials with permissions for both regions

### Current Cluster Information
- [x] Cluster identifier/name
- [x] Master username and password
- [x] Engine version (must match exactly)
- [x] Current instance types and count
- [x] Encryption status
- [x] Parameter group settings (if any)

### Network Requirements
- [x] VPC connectivity between regions (if cross-region access needed)
- [x] Proper security group rules for DocumentDB port (27017)
- [x] Route tables configured for subnet access

## Getting Started

### Step 1: Clone and Configure

```bash
# Navigate to the example directory
cd examples/global-cluster-conversion

# Copy the example variables file
cp terraform.tfvars.example terraform.tfvars

# Edit the file with your specific configuration
nano terraform.tfvars
```

### Step 2: Update Variables

Edit `terraform.tfvars` with your existing cluster information:

```hcl
# CRITICAL: These must match your existing cluster exactly
primary_cluster_identifier = "your-existing-cluster-name"
master_username           = "your-current-username"
master_password           = "your-current-password"
engine_version           = "4.0.0"  # Must match current version

# Regions
primary_region   = "us-east-1"  # Where your cluster exists
secondary_region = "us-west-2"  # Where DR cluster will be created

# Global cluster name
global_cluster_identifier = "your-global-cluster-name"
```

### Step 3: Initialize and Plan

```bash
# Initialize Terraform
terraform init

# Review the execution plan
terraform plan
```

**IMPORTANT**: Review the plan carefully to ensure:
- Your existing cluster will be **modified** (not destroyed/recreated)
- A new global cluster will be **created**
- A new secondary cluster will be **created** in the secondary region
- No data loss or downtime is indicated

### Step 4: Apply Configuration

```bash
# Apply the configuration
terraform apply

# Type 'yes' when prompted
```

The conversion process typically takes 15-20 minutes.

## What Happens During Conversion

### Phase 1: Global Cluster Creation (5-10 minutes)
1. Creates a new DocumentDB global cluster
2. Uses your existing cluster as the source/primary
3. Your existing cluster remains operational throughout

### Phase 2: Secondary Cluster Creation (10-15 minutes)
1. Creates a new DocumentDB cluster in the secondary region
2. Automatically configures it as a secondary of the global cluster
3. Begins initial data synchronization from primary

### Phase 3: Replication Establishment (1-5 minutes)
1. Establishes real-time cross-region replication
2. Secondary cluster becomes available for read operations
3. Global cluster is fully operational

## Verification

After successful deployment, verify the setup:

### Check Global Cluster Status
```bash
# View global cluster information
aws docdb describe-global-clusters \
  --global-cluster-identifier your-global-cluster-name

# Should show both clusters as members
```

### Test Connectivity
```bash
# Primary cluster (read/write)
mongosh "mongodb://username:password@primary-endpoint:27017/?ssl=true&replicaSet=rs0"

# Secondary cluster (read-only)
mongosh "mongodb://username:password@secondary-endpoint:27017/?ssl=true&replicaSet=rs0&readPreference=secondary"
```

### Monitor Replication
- Check AWS Console → DocumentDB → Global Clusters
- Monitor CloudWatch metrics for both clusters
- Verify cross-region replication lag (typically < 1 second)

## Configuration Options

### Authentication
```hcl
# The conversion scenario requires explicit authentication
master_username = "your-existing-username"
master_password = "your-existing-password"
manage_master_user_password = false  # Required for global clusters
```

### Encryption
```hcl
# Encryption configuration
storage_encrypted = true

# KMS keys are automatically created per region
# No manual KMS configuration required
```

### Instance Sizing
```hcl
# Primary cluster (your existing configuration)
primary_instance_count = 2
primary_instance_class = "db.r5.large"

# Secondary cluster (can be different for cost optimization)
secondary_instance_count = 1
secondary_instance_class = "db.t3.medium"
```

### Backup Configuration
```hcl
# Use different backup windows to avoid conflicts
preferred_backup_window = "07:00-09:00"  # Primary
secondary_preferred_backup_window = "10:00-12:00"  # Secondary

preferred_maintenance_window = "sun:05:00-sun:06:00"  # Primary
secondary_preferred_maintenance_window = "sun:08:00-sun:09:00"  # Secondary
```

## Disaster Recovery Operations

### Manual Failover
If the primary region becomes unavailable:

```bash
# Detach secondary cluster from global cluster
aws docdb remove-from-global-cluster \
  --global-cluster-identifier your-global-cluster-name \
  --db-cluster-identifier your-secondary-cluster-name

# The secondary cluster becomes a standalone regional cluster
# Update your application connection strings to point to secondary region
```

### Failback Process
When the primary region is restored:

1. Create a new global cluster with the former secondary as primary
2. Add the restored primary region cluster as the new secondary
3. Perform application failback when ready

## Monitoring and Alerting

The example includes basic CloudWatch monitoring:

### Available Metrics
- CPU utilization for both clusters
- Database connections
- Replication lag
- Storage metrics
- Network throughput

### SNS Alerts
- High CPU usage
- Connection limits approached
- Replication lag increases
- Cluster health issues

### Log Groups
- Audit logs: `/aws/docdb/{cluster-name}/audit`
- Profiler logs: `/aws/docdb/{cluster-name}/profiler`

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.primary"></a> [aws.primary](#provider\_aws.primary) | 5.100.0 |
| <a name="provider_aws.secondary"></a> [aws.secondary](#provider\_aws.secondary) | 5.100.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_primary_cluster"></a> [primary\_cluster](#module\_primary\_cluster) | ../../ | n/a |
| <a name="module_secondary_cluster"></a> [secondary\_cluster](#module\_secondary\_cluster) | ../../ | n/a |
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.3 |

## Resources

| Name | Type |
|------|------|
| [aws_subnets.primary_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.primary_private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.secondary_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.secondary_private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_vpc.secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_cidr_blocks"></a> [allowed\_cidr\_blocks](#input\_allowed\_cidr\_blocks) | List of CIDR blocks allowed to access DocumentDB | `list(string)` | <pre>[<br/>  "10.0.0.0/16"<br/>]</pre> | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | The days to retain backups for | `number` | `7` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Whether to enable deletion protection | `bool` | `true` | no |
| <a name="input_enabled_cloudwatch_logs_exports"></a> [enabled\_cloudwatch\_logs\_exports](#input\_enabled\_cloudwatch\_logs\_exports) | List of log types to export to CloudWatch | `list(string)` | <pre>[<br/>  "audit",<br/>  "profiler"<br/>]</pre> | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | DocumentDB engine version (must match existing cluster) | `string` | `"4.0.0"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name for primary cluster | `string` | `"prod"` | no |
| <a name="input_global_cluster_identifier"></a> [global\_cluster\_identifier](#input\_global\_cluster\_identifier) | Identifier for the global cluster | `string` | `null` | no |
| <a name="input_master_password"></a> [master\_password](#input\_master\_password) | Master password for the existing cluster (must match current cluster) | `string` | n/a | yes |
| <a name="input_master_username"></a> [master\_username](#input\_master\_username) | Master username for the existing cluster (must match current cluster) | `string` | `"docdbadmin"` | no |
| <a name="input_parameter_group_config"></a> [parameter\_group\_config](#input\_parameter\_group\_config) | DB cluster parameter group configuration | <pre>object({<br/>    create = optional(bool, false)<br/>    family = optional(string, "docdb4.0")<br/>    parameters = optional(list(object({<br/>      name  = string<br/>      value = string<br/>    })), [])<br/>  })</pre> | <pre>{<br/>  "create": false,<br/>  "family": "docdb4.0",<br/>  "parameters": [<br/>    {<br/>      "name": "tls",<br/>      "value": "enabled"<br/>    }<br/>  ]<br/>}</pre> | no |
| <a name="input_preferred_backup_window"></a> [preferred\_backup\_window](#input\_preferred\_backup\_window) | The daily time range during which automated backups are created | `string` | `"07:00-09:00"` | no |
| <a name="input_preferred_maintenance_window"></a> [preferred\_maintenance\_window](#input\_preferred\_maintenance\_window) | The weekly time range during which system maintenance can occur (primary) | `string` | `"sun:05:00-sun:06:00"` | no |
| <a name="input_primary_cluster_identifier"></a> [primary\_cluster\_identifier](#input\_primary\_cluster\_identifier) | Identifier of the existing cluster to convert to global | `string` | n/a | yes |
| <a name="input_primary_instance_class"></a> [primary\_instance\_class](#input\_primary\_instance\_class) | Instance class for primary cluster instances | `string` | `"db.t3.medium"` | no |
| <a name="input_primary_instance_count"></a> [primary\_instance\_count](#input\_primary\_instance\_count) | Number of instances in the primary cluster | `number` | `2` | no |
| <a name="input_primary_region"></a> [primary\_region](#input\_primary\_region) | AWS region where the existing cluster is located | `string` | `"us-east-1"` | no |
| <a name="input_primary_vpc_name"></a> [primary\_vpc\_name](#input\_primary\_vpc\_name) | Name tag of the VPC in the primary region | `string` | `"default"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project | `string` | `"docdb-global-conversion"` | no |
| <a name="input_secondary_cluster_identifier"></a> [secondary\_cluster\_identifier](#input\_secondary\_cluster\_identifier) | Identifier for the secondary (DR) cluster | `string` | `null` | no |
| <a name="input_secondary_instance_class"></a> [secondary\_instance\_class](#input\_secondary\_instance\_class) | Instance class for secondary cluster instances | `string` | `"db.t3.medium"` | no |
| <a name="input_secondary_instance_count"></a> [secondary\_instance\_count](#input\_secondary\_instance\_count) | Number of instances in the secondary cluster | `number` | `1` | no |
| <a name="input_secondary_preferred_backup_window"></a> [secondary\_preferred\_backup\_window](#input\_secondary\_preferred\_backup\_window) | The daily time range during which automated backups are created (secondary) | `string` | `"10:00-12:00"` | no |
| <a name="input_secondary_preferred_maintenance_window"></a> [secondary\_preferred\_maintenance\_window](#input\_secondary\_preferred\_maintenance\_window) | The weekly time range during which system maintenance can occur (secondary) | `string` | `"sun:08:00-sun:09:00"` | no |
| <a name="input_secondary_region"></a> [secondary\_region](#input\_secondary\_region) | AWS region for the disaster recovery cluster | `string` | `"us-west-2"` | no |
| <a name="input_secondary_vpc_name"></a> [secondary\_vpc\_name](#input\_secondary\_vpc\_name) | Name tag of the VPC in the secondary region | `string` | `"default"` | no |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Determines whether a final DB snapshot is created before deletion | `bool` | `false` | no |
| <a name="input_storage_encrypted"></a> [storage\_encrypted](#input\_storage\_encrypted) | Whether to encrypt the DocumentDB cluster | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_log_groups"></a> [cloudwatch\_log\_groups](#output\_cloudwatch\_log\_groups) | CloudWatch log groups created for both clusters |
| <a name="output_connection_info"></a> [connection\_info](#output\_connection\_info) | Connection information for both clusters |
| <a name="output_disaster_recovery_info"></a> [disaster\_recovery\_info](#output\_disaster\_recovery\_info) | Disaster recovery configuration summary |
| <a name="output_global_cluster_arn"></a> [global\_cluster\_arn](#output\_global\_cluster\_arn) | ARN of the global cluster |
| <a name="output_global_cluster_id"></a> [global\_cluster\_id](#output\_global\_cluster\_id) | ID of the global cluster |
| <a name="output_global_cluster_identifier"></a> [global\_cluster\_identifier](#output\_global\_cluster\_identifier) | Identifier of the global cluster |
| <a name="output_global_cluster_members"></a> [global\_cluster\_members](#output\_global\_cluster\_members) | List of clusters that are members of this global cluster |
| <a name="output_primary_cluster_arn"></a> [primary\_cluster\_arn](#output\_primary\_cluster\_arn) | ARN of the primary cluster |
| <a name="output_primary_cluster_endpoint"></a> [primary\_cluster\_endpoint](#output\_primary\_cluster\_endpoint) | Writer endpoint of the primary cluster |
| <a name="output_primary_cluster_hosted_zone_id"></a> [primary\_cluster\_hosted\_zone\_id](#output\_primary\_cluster\_hosted\_zone\_id) | Route53 hosted zone ID of the primary cluster |
| <a name="output_primary_cluster_id"></a> [primary\_cluster\_id](#output\_primary\_cluster\_id) | ID of the primary cluster |
| <a name="output_primary_cluster_identifier"></a> [primary\_cluster\_identifier](#output\_primary\_cluster\_identifier) | Identifier of the primary cluster |
| <a name="output_primary_cluster_port"></a> [primary\_cluster\_port](#output\_primary\_cluster\_port) | Port of the primary cluster |
| <a name="output_primary_cluster_reader_endpoint"></a> [primary\_cluster\_reader\_endpoint](#output\_primary\_cluster\_reader\_endpoint) | Reader endpoint of the primary cluster |
| <a name="output_primary_instance_endpoints"></a> [primary\_instance\_endpoints](#output\_primary\_instance\_endpoints) | List of individual instance endpoints in the primary cluster |
| <a name="output_primary_security_group_id"></a> [primary\_security\_group\_id](#output\_primary\_security\_group\_id) | Security group ID for the primary cluster |
| <a name="output_secondary_cluster_arn"></a> [secondary\_cluster\_arn](#output\_secondary\_cluster\_arn) | ARN of the secondary cluster |
| <a name="output_secondary_cluster_endpoint"></a> [secondary\_cluster\_endpoint](#output\_secondary\_cluster\_endpoint) | Writer endpoint of the secondary cluster |
| <a name="output_secondary_cluster_hosted_zone_id"></a> [secondary\_cluster\_hosted\_zone\_id](#output\_secondary\_cluster\_hosted\_zone\_id) | Route53 hosted zone ID of the secondary cluster |
| <a name="output_secondary_cluster_id"></a> [secondary\_cluster\_id](#output\_secondary\_cluster\_id) | ID of the secondary cluster |
| <a name="output_secondary_cluster_identifier"></a> [secondary\_cluster\_identifier](#output\_secondary\_cluster\_identifier) | Identifier of the secondary cluster |
| <a name="output_secondary_cluster_port"></a> [secondary\_cluster\_port](#output\_secondary\_cluster\_port) | Port of the secondary cluster |
| <a name="output_secondary_cluster_reader_endpoint"></a> [secondary\_cluster\_reader\_endpoint](#output\_secondary\_cluster\_reader\_endpoint) | Reader endpoint of the secondary cluster |
| <a name="output_secondary_instance_endpoints"></a> [secondary\_instance\_endpoints](#output\_secondary\_instance\_endpoints) | List of individual instance endpoints in the secondary cluster |
| <a name="output_secondary_security_group_id"></a> [secondary\_security\_group\_id](#output\_secondary\_security\_group\_id) | Security group ID for the secondary cluster |
<!-- END_TF_DOCS -->

## Cost Considerations

### Instance Costs
- **Primary**: Continue with existing instance sizes
- **Secondary**: Consider smaller instances for cost optimization
- **Cross-region traffic**: Data transfer charges apply for replication

### Storage Costs
- **Secondary region**: Additional storage costs for replicated data
- **Backup storage**: Backups stored in both regions

### Optimization Tips
- Use smaller instance types in secondary region if read performance isn't critical
- Adjust backup retention periods based on recovery requirements
- Monitor and right-size instances based on actual usage

## Troubleshooting

### Common Issues

#### Error: "Cannot specify user name for cross region replication cluster"
**Solution**: Remove `master_username` from secondary cluster configuration. AWS manages authentication automatically.

#### Error: "kmsKeyId should be explicitly specified"
**Solution**: The module automatically handles KMS keys. Ensure `storage_encrypted = true` is set.

#### Connection timeout to secondary cluster
**Solution**:
- Check security group rules allow port 27017
- Verify VPC routing between regions
- Confirm secondary cluster is in "available" state

#### Replication lag is high
**Solution**:
- Check network connectivity between regions
- Monitor CloudWatch metrics for bottlenecks
- Consider increasing instance sizes if needed

### Getting Help
- Check AWS DocumentDB CloudWatch metrics
- Review CloudTrail logs for API errors
- Consult AWS Support for region-specific issues
- Monitor replication status in AWS Console

## Cleanup

To remove the global cluster setup:

```bash
# This will:
# 1. Remove secondary cluster
# 2. Remove global cluster
# 3. Convert primary back to regional cluster
terraform destroy
```

**WARNING**: This will destroy the secondary cluster and remove cross-region replication. Your primary cluster will remain as a regional cluster.

## Additional Resources

- [AWS DocumentDB Global Clusters Documentation](https://docs.aws.amazon.com/documentdb/latest/developerguide/global-clusters.html)
- [DocumentDB Disaster Recovery Guide](https://docs.aws.amazon.com/documentdb/latest/developerguide/backup_restore.html)
- [Cross-Region Replication Best Practices](https://docs.aws.amazon.com/documentdb/latest/developerguide/global-clusters-best-practices.html)
- [Module Usage Guide](../../docs/module-usage-guide/README.md)
