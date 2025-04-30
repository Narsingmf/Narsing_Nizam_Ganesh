###################################################
# Output values from the Terraform configuration
###################################################
# This file defines the outputs that will be displayed after terraform apply
# These outputs provide important information about the created resources

# Networking outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.networking.vpc_id
  # This output is useful for integrating with other infrastructure that needs to be in the same VPC
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = module.networking.public_subnet_ids
  # Public subnets are used for resources that need direct internet access (like the ALB)
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = module.networking.private_subnet_ids
  # Private subnets are used for resources that don't need direct internet access (like ECS tasks)
}

# ECS outputs
output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = module.ecs.cluster_name
  # Useful for CLI commands or integrating with CI/CD pipelines
}

output "ecs_cluster_id" {
  description = "The ID of the ECS cluster"
  value       = module.ecs.cluster_id
  # Unique identifier for the ECS cluster
}

output "ecs_service_name" {
  description = "The name of the ECS service"
  value       = module.ecs.service_name
  # Useful for CLI commands or monitoring
}

output "load_balancer_dns" {
  description = "The DNS name of the load balancer"
  value       = module.ecs.load_balancer_dns
  # This is the endpoint URL where your application can be accessed
}