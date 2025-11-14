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

output "cluster_arn" {
  description = "Amazon Resource Name (ARN) of the cluster"
  value       = module.documentdb_cluster.cluster_arn
}

output "cluster_port" {
  description = "The database port"
  value       = module.documentdb_cluster.cluster_port
}

output "cluster_members" {
  description = "List of DocumentDB Instances that are a part of this cluster"
  value       = module.documentdb_cluster.cluster_members
}

output "instance_ids" {
  description = "List of DocumentDB instance identifiers"
  value       = module.documentdb_cluster.instance_ids
}

output "instance_endpoints" {
  description = "List of DocumentDB instance endpoints"
  value       = module.documentdb_cluster.instance_endpoints
}

output "security_group_id" {
  description = "The ID of the security group created for the DocumentDB cluster"
  value       = module.documentdb_cluster.security_group_id
}

output "secret_arn" {
  description = "The ARN of the secret containing master credentials"
  value       = module.documentdb_cluster.secret_arn
}

output "kms_key_arn" {
  description = "The Amazon Resource Name (ARN) of the KMS key"
  value       = module.documentdb_cluster.kms_key_arn
}

output "db_cluster_parameter_group_name" {
  description = "The name of the DB cluster parameter group"
  value       = module.documentdb_cluster.db_cluster_parameter_group_name
}

output "master_username" {
  description = "The master username for the DB cluster"
  value       = module.documentdb_cluster.master_username
}
