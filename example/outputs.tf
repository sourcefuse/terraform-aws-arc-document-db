output "example_cluster_name" {
  description = "DocumentDB Cluster Identifier"
  value       = module.doc_db_cluster.cluster_name
}

output "example_arn" {
  description = "Amazon Resource Name (ARN) of the DocumentDB cluster"
  value       = module.doc_db_cluster.arn
}

output "example_endpoint" {
  description = "Endpoint of the DocumentDB cluster"
  value       = module.doc_db_cluster.endpoint
}

output "example_reader_endpoint" {
  description = "Read-only endpoint of the DocumentDB cluster, automatically load-balanced across replicas"
  value       = module.doc_db_cluster.reader_endpoint
}
