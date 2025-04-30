###################################################
# Main Terraform configuration file
###################################################
# This is the root module that orchestrates the creation of all AWS resources
# by calling the specialized sub-modules for networking, IAM, and ECS.

# Call the networking module to set up VPC and subnets
# This module creates the foundational network infrastructure:
# - VPC with specified CIDR block
# - Public subnets with Internet Gateway for external access
# - Private subnets with NAT Gateway for outbound-only access
# - Route tables and security groups
module "networking" {
  source = "./modules/networking"

  environment         = var.environment  # Deployment environment (dev, staging, prod)
  vpc_cidr            = var.vpc_cidr     # CIDR block for the entire VPC
  availability_zones  = var.availability_zones  # AZs to distribute resources across
  public_subnet_cidrs = var.public_subnet_cidrs # CIDR blocks for public subnets
  private_subnet_cidrs = var.private_subnet_cidrs # CIDR blocks for private subnets
}

# Call the IAM module to set up necessary roles and policies
# This module creates the IAM roles and policies required for ECS:
# - ECS Task Execution Role: Allows ECS to pull images and publish logs
# - ECS Task Role: Permissions for the application running inside containers
module "iam" {
  source = "./modules/iam"

  environment = var.environment  # Used for resource naming and tagging
  project     = var.project_name # Used for resource naming and tagging
}

# Call the ECS module to set up the ECS cluster, service, and task definition
# This module creates the container orchestration infrastructure:
# - ECS Cluster: Logical grouping of tasks and services
# - Task Definition: Container specifications (image, CPU, memory, ports)
# - ECS Service: Maintains desired count of tasks and integrates with load balancer
# - Application Load Balancer: Distributes traffic to containers
# - Auto Scaling: Adjusts task count based on CPU and memory utilization
module "ecs" {
  source = "./modules/ecs"

  environment      = var.environment      # Deployment environment
  project_name     = var.project_name     # Project name for resource naming
  region           = var.region           # AWS region for resources
  vpc_id           = module.networking.vpc_id  # VPC ID from networking module
  public_subnets   = module.networking.public_subnet_ids   # Public subnet IDs for ALB
  private_subnets  = module.networking.private_subnet_ids  # Private subnet IDs for ECS tasks
  ecs_service_name = var.ecs_service_name # Name of the ECS service
  container_name   = var.container_name   # Name of the container
  container_image  = var.container_image  # Docker image to deploy
  container_port   = var.container_port   # Port the container exposes
  cpu              = var.cpu              # CPU units for the task
  memory           = var.memory           # Memory for the task in MiB
  desired_count    = var.desired_count    # Desired number of tasks to run
  execution_role_arn = module.iam.ecs_execution_role_arn  # Role for ECS to execute tasks
  task_role_arn    = module.iam.ecs_task_role_arn         # Role for the container tasks
}