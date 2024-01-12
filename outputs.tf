output "cluster_name" {
  value       = module.doc_db_cluster.cluster_name
  description = "DocumentDB Cluster Identifier"
}

output "arn" {
  value       = module.doc_db_cluster.arn
  description = "Amazon Resource Name (ARN) of the DocumentDB cluster"
}

output "endpoint" {
  value       = module.doc_db_cluster.endpoint
  description = "Endpoint of the DocumentDB cluster"
}

output "reader_endpoint" {
  value       = module.doc_db_cluster.reader_endpoint
  description = "Read-only endpoint of the DocumentDB cluster, automatically load-balanced across replicas"
}
