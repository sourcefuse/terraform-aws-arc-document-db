# =============================================================================
# GLOBAL CLUSTER OUTPUTS
# =============================================================================

output "global_cluster_arn" {
  description = "ARN of the global cluster"
  value       = module.primary_cluster.global_cluster_arn
}

output "global_cluster_id" {
  description = "ID of the global cluster"
  value       = module.primary_cluster.global_cluster_id
}

output "global_cluster_identifier" {
  description = "Identifier of the global cluster"
  value       = module.primary_cluster.global_cluster_identifier
}

output "global_cluster_members" {
  description = "List of clusters that are members of this global cluster"
  value       = module.primary_cluster.global_cluster_members
}

# =============================================================================
# PRIMARY CLUSTER OUTPUTS
# =============================================================================

output "primary_cluster_arn" {
  description = "ARN of the primary cluster"
  value       = module.primary_cluster.cluster_arn
}

output "primary_cluster_id" {
  description = "ID of the primary cluster"
  value       = module.primary_cluster.cluster_id
}

output "primary_cluster_identifier" {
  description = "Identifier of the primary cluster"
  value       = module.primary_cluster.cluster_identifier
}

output "primary_cluster_endpoint" {
  description = "Writer endpoint of the primary cluster"
  value       = module.primary_cluster.cluster_endpoint
}

output "primary_cluster_reader_endpoint" {
  description = "Reader endpoint of the primary cluster"
  value       = module.primary_cluster.cluster_reader_endpoint
}

output "primary_cluster_port" {
  description = "Port of the primary cluster"
  value       = module.primary_cluster.cluster_port
}

output "primary_cluster_hosted_zone_id" {
  description = "Route53 hosted zone ID of the primary cluster"
  value       = module.primary_cluster.cluster_hosted_zone_id
}

output "primary_instance_endpoints" {
  description = "List of individual instance endpoints in the primary cluster"
  value       = module.primary_cluster.instance_endpoints
}

output "primary_security_group_id" {
  description = "Security group ID for the primary cluster"
  value       = module.primary_cluster.security_group_id
}

# =============================================================================
# SECONDARY CLUSTER OUTPUTS
# =============================================================================

output "secondary_cluster_arn" {
  description = "ARN of the secondary cluster"
  value       = module.secondary_cluster.cluster_arn
}

output "secondary_cluster_id" {
  description = "ID of the secondary cluster"
  value       = module.secondary_cluster.cluster_id
}

output "secondary_cluster_identifier" {
  description = "Identifier of the secondary cluster"
  value       = module.secondary_cluster.cluster_identifier
}

output "secondary_cluster_endpoint" {
  description = "Writer endpoint of the secondary cluster"
  value       = module.secondary_cluster.cluster_endpoint
}

output "secondary_cluster_reader_endpoint" {
  description = "Reader endpoint of the secondary cluster"
  value       = module.secondary_cluster.cluster_reader_endpoint
}

output "secondary_cluster_port" {
  description = "Port of the secondary cluster"
  value       = module.secondary_cluster.cluster_port
}

output "secondary_cluster_hosted_zone_id" {
  description = "Route53 hosted zone ID of the secondary cluster"
  value       = module.secondary_cluster.cluster_hosted_zone_id
}

output "secondary_instance_endpoints" {
  description = "List of individual instance endpoints in the secondary cluster"
  value       = module.secondary_cluster.instance_endpoints
}

output "secondary_security_group_id" {
  description = "Security group ID for the secondary cluster"
  value       = module.secondary_cluster.security_group_id
}

# =============================================================================
# CONNECTION INFORMATION
# =============================================================================

output "connection_info" {
  description = "Connection information for both clusters"
  value = {
    primary = {
      endpoint        = module.primary_cluster.cluster_endpoint
      reader_endpoint = module.primary_cluster.cluster_reader_endpoint
      port            = module.primary_cluster.cluster_port
      region          = var.primary_region
    }
    secondary = {
      endpoint        = module.secondary_cluster.cluster_endpoint
      reader_endpoint = module.secondary_cluster.cluster_reader_endpoint
      port            = module.secondary_cluster.cluster_port
      region          = var.secondary_region
    }
  }
}

# =============================================================================
# MONITORING OUTPUTS
# =============================================================================

output "cloudwatch_log_groups" {
  description = "CloudWatch log groups created for both clusters"
  value = {
    primary = {
      audit_log_group    = module.primary_cluster.cloudwatch_log_group_audit_name
      profiler_log_group = module.primary_cluster.cloudwatch_log_group_profiler_name
    }
    secondary = {
      audit_log_group    = module.secondary_cluster.cloudwatch_log_group_audit_name
      profiler_log_group = module.secondary_cluster.cloudwatch_log_group_profiler_name
    }
  }
}


# =============================================================================
# DISASTER RECOVERY INFORMATION
# =============================================================================

output "disaster_recovery_info" {
  description = "Disaster recovery configuration summary"
  value = {
    primary_region   = var.primary_region
    secondary_region = var.secondary_region
    global_cluster   = module.primary_cluster.global_cluster_identifier
    replication_lag  = "Cross-region replication typically has sub-second latency"
    failover_method  = "Manual failover via AWS Console or CLI"
    rpo_estimate     = "< 1 second (near real-time replication)"
    rto_estimate     = "< 5 minutes (manual failover + DNS propagation)"
  }
}
