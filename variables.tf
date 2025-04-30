###################################################
# Input variables for the Terraform configuration
###################################################
# This file defines all the variables that can be customized when deploying the infrastructure

# General configuration variables
variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
  # The AWS region determines where your infrastructure will be physically located
}

variable "environment" {
  description = "The environment (dev, staging, prod)"
  type        = string
  default     = "dev"
  # Used for naming resources and applying environment-specific configurations
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "my-ecs-app"
  # Used for naming and tagging resources
}

# VPC and Networking variables
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
  # Defines the IP address range for the entire VPC (65,536 IP addresses)
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
  # Using multiple AZs provides high availability and fault tolerance
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
  # Each public subnet gets 256 IP addresses (10.0.1.0 - 10.0.1.255, etc.)
  # Public subnets have direct internet access via Internet Gateway
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
  # Each private subnet gets 256 IP addresses (10.0.3.0 - 10.0.3.255, etc.)
  # Private subnets access internet via NAT Gateway
}

# ECS variables
variable "ecs_service_name" {
  description = "Name of the ECS service"
  type        = string
  default     = "app-service"
  # The ECS service maintains the desired count of tasks
}

variable "container_name" {
  description = "Name of the container"
  type        = string
  default     = "app-container"
  # Used in task definition and load balancer target group
}

variable "container_image" {
  description = "Docker image for the container"
  type        = string
  default     = "nginx:latest"
  # The Docker image to deploy (format: repository/image:tag)
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
  default     = 80
  # The port that your application listens on inside the container
}

variable "cpu" {
  description = "CPU units for the task"
  type        = number
  default     = 256
  # 1 vCPU = 1024 CPU units, so 256 = 1/4 vCPU
}

variable "memory" {
  description = "Memory for the task in MiB"
  type        = number
  default     = 512
  # Memory allocated to the container in MiB
}

variable "desired_count" {
  description = "Desired count of tasks"
  type        = number
  default     = 2
  # Number of task instances to run (for high availability)
}