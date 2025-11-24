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
