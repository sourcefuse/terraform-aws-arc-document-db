#######################################################################
## shared
#######################################################################
variable "namespace" {
  type        = string
  description = "Namespace for the resources."
}

variable "environment" {
  type        = string
  default     = "poc"
  description = "environment value, e.g 'prod', 'staging', 'dev', 'UAT'"
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "The project name"
  default     = ""
}

###### documentdb cluster variables

variable "cluster_size" {
  type        = number
  description = "Number of instances to create in the cluster"
  default     = 1
}

variable "doc_db_cluster_name" {
  type        = string
  description = "Name of the DocumentDB cluster"
  default     = ""
}

variable "instance_class" {
  type        = string
  description = "Instance class to use"
  default     = ""
}

variable "master_username" {
  type        = string
  description = "Username for the master DB user"
  default     = ""
}
