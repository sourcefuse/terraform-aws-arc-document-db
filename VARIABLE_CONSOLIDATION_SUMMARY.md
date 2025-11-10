# DocumentDB Module Variable Consolidation Summary

## Current State: 50+ variables
## Target State: ~15 variables (70% reduction)

### ✅ Already Consolidated (6 config objects):
1. **kms_config** - KMS encryption settings
2. **subnet_config** - Subnet group configuration  
3. **parameter_group_config** - DB parameter group settings
4. **secret_config** - Secrets Manager configuration
5. **alarm_config** - CloudWatch alarms configuration
6. **event_subscription_config** - Event subscription settings

### 🔄 Ready for Consolidation:

#### 1. Instance Configuration (6 → 1 variable)
```hcl
variable "instance_config" {
  type = object({
    count                = optional(number, 1)
    class                = optional(string, "db.t3.medium")
    identifier_prefix    = optional(string, null)
    promotion_tiers      = optional(map(number), {})
    availability_zones   = optional(list(string), null)
    ca_cert_identifier   = optional(string, null)
  })
}
```

#### 2. Security Group Configuration (8 → 1 variable)
```hcl
variable "security_group_config" {
  type = object({
    create_security_group        = optional(bool, true)
    vpc_id                      = optional(string, null)
    security_group_ids          = optional(list(string), [])
    vpc_security_group_ids      = optional(list(string), [])
    ingress_rules              = optional(list(any), [])
    egress_rules               = optional(list(any), [])
    allowed_cidr_blocks        = optional(list(string), [])
    allowed_security_group_ids = optional(list(string), [])
  })
}
```

#### 3. Backup & Maintenance Configuration (6 → 1 variable)
```hcl
variable "backup_maintenance_config" {
  type = object({
    backup_retention_period      = optional(number, 7)
    preferred_backup_window      = optional(string, "07:00-09:00")
    preferred_maintenance_window = optional(string, "sun:05:00-sun:06:00")
    apply_immediately           = optional(bool, false)
    auto_minor_version_upgrade  = optional(bool, true)
    allow_major_version_upgrade = optional(bool, false)
  })
}
```

#### 4. Monitoring Configuration (5 → 1 variable)
```hcl
variable "monitoring_config" {
  type = object({
    monitoring_interval           = optional(number, 0)
    create_monitoring_role       = optional(bool, false)
    cloudwatch_log_retention_days = optional(number, 7)
    cloudwatch_log_kms_key_id    = optional(string, null)
    treat_missing_data           = optional(string, "missing")
  })
}
```

#### 5. Global Cluster Configuration (5 → 1 variable)
```hcl
variable "global_cluster_config" {
  type = object({
    create_global_cluster              = optional(bool, false)
    global_cluster_identifier         = optional(string, null)
    source_db_cluster_identifier      = optional(string, null)
    is_secondary_cluster              = optional(bool, false)
    existing_global_cluster_identifier = optional(string, null)
  })
}
```

### 📊 Impact Summary:
- **Before**: 50+ individual variables
- **After**: ~15 variables (6 existing configs + 5 new configs + 4 core variables)
- **Reduction**: 70% fewer variables
- **Benefits**:
  - Cleaner interface
  - Logical grouping
  - Better defaults
  - Easier maintenance
  - Consistent with existing pattern

### 🎯 Implementation Priority:
1. **High Impact**: Instance, Security Group, Backup configs (20 variables → 3)
2. **Medium Impact**: Monitoring, Global cluster configs (10 variables → 2)  
3. **Low Impact**: Remaining individual variables

Would you like me to implement any of these consolidations?
