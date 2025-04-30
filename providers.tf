###################################################
# Provider configuration
###################################################
# This file configures the AWS provider and sets default tags for all resources

terraform {
  # Define required provider versions for compatibility
  required_providers {
    aws = {
      source  = "hashicorp/aws"  # Official AWS provider from HashiCorp
      version = "~> 4.0"         # Compatible with version 4.x
    }
  }
  required_version = ">= 1.0.0"  # Requires Terraform 1.0.0 or newer
}

provider "aws" {
  region = var.region  # AWS region where resources will be created

  # Apply default tags to all resources created by this provider
  # These tags help with resource organization, cost allocation, and management
  default_tags {
    tags = {
      Environment = var.environment  # Indicates deployment environment (dev, staging, prod)
      Project     = var.project_name # Project name for resource grouping
      ManagedBy   = "Terraform"      # Indicates resources are managed by Terraform
    }
  }
}