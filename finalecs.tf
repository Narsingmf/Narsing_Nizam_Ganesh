# This file serves as an entry point to the Terraform configuration
# The actual implementation is organized in a modular structure

###################################################
# ECS Project Overview and Usage Guide
###################################################

# This Terraform project deploys a containerized application on AWS ECS (Elastic Container Service)
# with a complete infrastructure including networking, security, and auto-scaling capabilities.

# Architecture Overview:
# ---------------------
# - VPC with public and private subnets across multiple availability zones
# - Internet Gateway for public subnets and NAT Gateway for private subnets
# - Application Load Balancer (ALB) in public subnets to route traffic
# - ECS Fargate tasks running in private subnets for security
# - Auto-scaling based on CPU and memory utilization
# - CloudWatch for logging and monitoring

# To use this Terraform configuration:
# -----------------------------------
# 1. Initialize Terraform: terraform init
#    - Downloads required providers
#    - Sets up backend for state storage
#
# 2. Plan the deployment: terraform plan -out=tfplan
#    - Validates configuration
#    - Shows resources to be created
#    - Creates execution plan
#
# 3. Apply the configuration: terraform apply tfplan
#    - Creates all resources
#    - Outputs important information like load balancer DNS

# The main configuration is split into modules:
# -------------------------------------------
# - main.tf: Main configuration file that calls the modules
# - variables.tf: Input variables for the configuration
# - outputs.tf: Output values from the configuration
# - providers.tf: Provider configuration
# - backend.tf: State management configuration

# Modules:
# -------
# - networking: VPC, subnets, security groups, gateways, and routing
# - iam: IAM roles and policies for ECS tasks
# - ecs: ECS cluster, service, task definition, load balancer, and auto-scaling

# For state management, an S3 backend with DynamoDB locking is configured
# This ensures safe collaboration and state versioning

# Customization:
# ------------
# - Modify variables.tf to change default values
# - For environment-specific configurations, create terraform.tfvars files