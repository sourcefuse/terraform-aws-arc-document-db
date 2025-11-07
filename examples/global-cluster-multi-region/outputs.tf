output "global_cluster_arn" {
  description = "Amazon Resource Name (ARN) of the global cluster"
  value       = module.primary_cluster.global_cluster_arn
}

output "global_cluster_identifier" {
  description = "The DocumentDB global cluster identifier"
  value       = module.primary_cluster.global_cluster_identifier
}

output "global_cluster_members" {
  description = "List of DocumentDB Clusters that are part of this global cluster"
  value       = module.primary_cluster.global_cluster_members
}

# Primary cluster outputs
output "primary_cluster_endpoint" {
  description = "The DNS address of the primary DocumentDB cluster"
  value       = module.primary_cluster.cluster_endpoint
}

output "primary_cluster_reader_endpoint" {
  description = "A read-only endpoint for the primary DocumentDB cluster"
  value       = module.primary_cluster.cluster_reader_endpoint
}

output "primary_cluster_id" {
  description = "The primary DocumentDB cluster identifier"
  value       = module.primary_cluster.cluster_id
}

output "primary_secret_arn" {
  description = "The ARN of the secret containing primary cluster credentials"
  value       = module.primary_cluster.secret_arn
}

# Secondary cluster outputs
output "secondary_cluster_endpoint" {
  description = "The DNS address of the secondary DocumentDB cluster"
  value       = module.secondary_cluster.cluster_endpoint
}

output "secondary_cluster_reader_endpoint" {
  description = "A read-only endpoint for the secondary DocumentDB cluster"
  value       = module.secondary_cluster.cluster_reader_endpoint
}

output "secondary_cluster_id" {
  description = "The secondary DocumentDB cluster identifier"
  value       = module.secondary_cluster.cluster_id
}

# Connection information
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
