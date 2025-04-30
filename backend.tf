###################################################
# Terraform state management configuration
###################################################

terraform {
  backend "s3" {
    bucket         = "terraform-state-ecs-project"  # Replace with your S3 bucket name
    key            = "terraform.tfstate"
    region         = "us-east-1"                    # Replace with your preferred region
    encrypt        = true
    dynamodb_table = "terraform-locks"              # DynamoDB table for state locking
  }
}

# Note: You need to create the S3 bucket and DynamoDB table before initializing Terraform
# You can use the following AWS CLI commands:
#
# aws s3 mb s3://terraform-state-ecs-project --region us-east-1
#
# aws dynamodb create-table \
#   --table-name terraform-locks \
#   --attribute-definitions AttributeName=LockID,AttributeType=S \
#   --key-schema AttributeName=LockID,KeyType=HASH \
#   --billing-mode PAY_PER_REQUEST \
#   --region us-east-1