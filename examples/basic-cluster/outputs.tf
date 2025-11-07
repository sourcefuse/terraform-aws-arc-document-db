output "cluster_endpoint" {
  description = "The DNS address of the DocumentDB instance"
  value       = module.documentdb_cluster.cluster_endpoint
}

output "cluster_reader_endpoint" {
  description = "A read-only endpoint for the DocumentDB cluster"
  value       = module.documentdb_cluster.cluster_reader_endpoint
}

output "cluster_id" {
  description = "The DocumentDB cluster identifier"
  value       = module.documentdb_cluster.cluster_id
}

output "cluster_port" {
  description = "The database port"
  value       = module.documentdb_cluster.cluster_port
}

output "instance_ids" {
  description = "List of DocumentDB instance identifiers"
  value       = module.documentdb_cluster.instance_ids
}

output "security_group_id" {
  description = "The ID of the security group created for the DocumentDB cluster"
  value       = module.documentdb_cluster.security_group_id
}
