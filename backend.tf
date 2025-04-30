###################################################
# Terraform state management configuration
###################################################
# This file configures remote state storage for collaboration and state locking

terraform {
  # Configure S3 backend for remote state storage
  # This enables team collaboration and provides state versioning
  backend "s3" {
    bucket         = "terraform-state-ecs-project"  # S3 bucket to store state files
    key            = "terraform.tfstate"            # Path to state file within bucket
    region         = "us-east-1"                    # AWS region for the S3 bucket
    encrypt        = true                           # Encrypt state file at rest
    dynamodb_table = "terraform-locks"              # DynamoDB table for state locking
  }
}

# Note: You need to create the S3 bucket and DynamoDB table before initializing Terraform
# You can use the following AWS CLI commands:
#
# 1. Create the S3 bucket for state storage:
# aws s3 mb s3://terraform-state-ecs-project --region us-east-1
#
# 2. Create the DynamoDB table for state locking:
# aws dynamodb create-table \
#   --table-name terraform-locks \
#   --attribute-definitions AttributeName=LockID,AttributeType=S \
#   --key-schema AttributeName=LockID,KeyType=HASH \
#   --billing-mode PAY_PER_REQUEST \
#   --region us-east-1