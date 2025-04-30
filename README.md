# Terraform ECS Project

This project contains Terraform code to create an ECS instance using best practices like code modularity and state management.

## Project Structure

```
.
├── backend.tf          # State management configuration
├── finalecs.tf         # Entry point file with documentation
├── main.tf             # Main configuration file
├── modules/            # Modular components
│   ├── ecs/            # ECS cluster, service, task definition
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── iam/            # IAM roles and policies
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── networking/     # VPC, subnets, security groups
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── outputs.tf          # Output values
├── providers.tf        # Provider configuration
├── README.md           # This file
├── test/               # Test scripts
│   └── test_terraform.sh
└── variables.tf        # Input variables
```

## Features

- **Modular Design**: Code is organized into reusable modules
- **Remote State Management**: Uses S3 backend with DynamoDB locking
- **Scalable ECS Setup**: Includes auto-scaling configuration
- **Networking**: Complete VPC setup with public and private subnets
- **Security**: Proper IAM roles and security groups

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform v1.0.0 or newer
- S3 bucket and DynamoDB table for state management (see backend.tf)

## Usage

1. Initialize the Terraform configuration:
   ```
   terraform init
   ```

2. Review the execution plan:
   ```
   terraform plan
   ```

3. Apply the configuration:
   ```
   terraform apply
   ```

4. When finished, destroy the resources:
   ```
   terraform destroy
   ```

## State Management

This project uses an S3 backend with DynamoDB locking for state management. Before initializing Terraform, you need to create:

1. An S3 bucket for storing the state file
2. A DynamoDB table for state locking

You can create these resources using the AWS CLI commands commented in the `backend.tf` file.

## Customization

Modify the `variables.tf` file or create a `terraform.tfvars` file to customize the deployment according to your requirements.

## Testing

Run the test script to validate the Terraform configuration:

```
bash test/test_terraform.sh
```