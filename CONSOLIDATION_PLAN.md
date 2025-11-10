# Variable Consolidation Plan

## Current Status: 50+ variables → Target: ~15 variables

### 1. Cluster Configuration (15 variables → 1)
**Consolidate into `cluster_config`:**
- cluster_identifier
- cluster_identifier_prefix  
- engine
- engine_version
- database_name
- port
- master_username
- master_password
- manage_master_user_password
- storage_encrypted
- deletion_protection
- skip_final_snapshot
- final_snapshot_identifier
- snapshot_identifier
- copy_tags_to_snapshot
- availability_zones
- enabled_cloudwatch_logs_exports

### 2. Backup & Maintenance Configuration (6 variables → 1)
**Consolidate into `backup_maintenance_config`:**
- backup_retention_period
- preferred_backup_window
- preferred_maintenance_window
- apply_immediately
- auto_minor_version_upgrade
- allow_major_version_upgrade

### 3. Instance Configuration (6 variables → 1)
**Consolidate into `instance_config`:**
- instance_count
- instance_class
- instance_identifier_prefix
- instance_promotion_tiers
- instance_availability_zones
- ca_cert_identifier

### 4. Security Group Configuration (7 variables → 1)
**Consolidate into `security_group_config`:**
- create_security_group
- vpc_id
- security_group_ids
- vpc_security_group_ids
- ingress_rules
- egress_rules
- allowed_cidr_blocks
- allowed_security_group_ids

### 5. Monitoring Configuration (4 variables → 1)
**Consolidate into `monitoring_config`:**
- monitoring_interval
- create_monitoring_role
- cloudwatch_log_retention_in_days
- cloudwatch_log_kms_key_id
- treat_missing_data

### 6. Global Cluster Configuration (4 variables → 1)
**Consolidate into `global_cluster_config`:**
- create_global_cluster
- global_cluster_identifier
- source_db_cluster_identifier
- is_secondary_cluster
- existing_global_cluster_identifier

### 7. Event Subscription Configuration (3 variables → 1)
**Consolidate into `event_subscription_config`:** ✅ DONE
- create_event_subscription
- event_subscription_name
- sns_topic_arn

### 8. Secrets Configuration (4 variables → 1)
**Consolidate into `secrets_config`:**
- force_overwrite_replica_secret
- replica_region
- replica_kms_key_id
- secret_version_stages

## Already Consolidated:
- ✅ kms_config (3 variables)
- ✅ subnet_config (3 variables)
- ✅ parameter_group_config (4 variables)
- ✅ secret_config (4 variables)
- ✅ alarm_config (8 variables)
- ✅ event_subscription_config (4 variables)

## Keep Separate (Core variables):
- tags
- name_prefix
- environment
- additional_policy_arns
