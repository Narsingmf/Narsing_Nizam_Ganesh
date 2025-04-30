# AWS ECS Infrastructure as Code with Terraform and CI/CD Pipeline

This project provides a comprehensive Infrastructure as Code (IaC) solution for deploying containerized applications on AWS ECS (Elastic Container Service) with a complete CI/CD pipeline. It combines Terraform modules for infrastructure provisioning and a reusable Node.js pipeline template for automated deployments.

The project implements a production-grade infrastructure with multi-AZ deployment, secure networking, auto-scaling capabilities, and blue-green deployment strategy. It features comprehensive monitoring, security scanning, and quality checks throughout the deployment pipeline. The modular design allows for easy customization and maintenance while following AWS best practices.

## Repository Structure
```
.
├── ci/                                 # CI/CD pipeline configurations
│   └── nodejs-pipeline-template.yml    # Reusable Node.js pipeline template with blue-green deployment
├── modules/                            # Terraform modules for infrastructure components
│   ├── ecs/                           # ECS cluster, service, and task definitions
│   ├── iam/                           # IAM roles and policies for ECS
│   └── networking/                    # VPC, subnets, and security groups
├── Narsing_Nizam_Ganesh/              # Main Terraform configuration
│   ├── backend.tf                     # S3 backend configuration for state management
│   ├── finalecs.tf                    # ECS deployment entry point
│   ├── main.tf                        # Root module orchestrating all components
│   └── variables.tf                   # Input variables for configuration
└── test/                              # Testing utilities
    └── test_terraform.sh              # Terraform configuration validation script
```

## Usage Instructions
### Prerequisites
- AWS CLI configured with appropriate credentials
- Terraform >= 0.12.x
- Node.js >= 18.x (for pipeline execution)
- Docker (for container builds)
- kubectl (for Kubernetes deployments)
- yamllint (for pipeline template validation)

### Installation

1. Clone the repository and initialize Terraform:
```bash
git clone <repository-url>
cd <repository-name>
terraform init
```

2. Configure AWS credentials:
```bash
aws configure
```

3. Create the S3 bucket for Terraform state:
```bash
aws s3 mb s3://terraform-state-ecs-project --region us-east-1
```

4. Create the DynamoDB table for state locking:
```bash
aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

### Quick Start
1. Configure variables:
```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your desired values
```

2. Plan and apply the infrastructure:
```bash
terraform plan -out=tfplan
terraform apply tfplan
```

### More Detailed Examples

1. Deploying with custom VPC configuration:
```hcl
module "networking" {
  source = "./modules/networking"
  
  environment = "prod"
  vpc_cidr = "10.0.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
}
```

2. Configuring ECS service with auto-scaling:
```hcl
module "ecs" {
  source = "./modules/ecs"
  
  environment = "prod"
  cpu = 256
  memory = 512
  desired_count = 2
  container_port = 80
}
```

### Troubleshooting

1. State Lock Issues
```bash
# Clear stuck state lock
aws dynamodb delete-item \
  --table-name terraform-locks \
  --key '{"LockID": {"S": "terraform-state-lock-id"}}' \
  --region us-east-1
```

2. ECS Service Deployment Issues
- Check ECS service events:
```bash
aws ecs describe-services --cluster <cluster-name> --services <service-name>
```
- View container logs:
```bash
aws logs get-log-events --log-group-name /ecs/<service-name> --log-stream-name <container-id>
```

## Data Flow

The infrastructure implements a secure multi-tier architecture with public and private subnets, where applications run in private subnets with controlled access through an Application Load Balancer.

```ascii
                                     ┌──────────────┐
                                     │    Client    │
                                     └──────┬───────┘
                                            │
                                            ▼
┌────────────────────────────────────────────────────────────────┐
│                           VPC                                   │
│  ┌─────────────┐      ┌──────────┐      ┌──────────────────┐  │
│  │    ALB      │─────▶│   ECS    │─────▶│  Container Apps  │  │
│  └─────────────┘      │ Service  │      └──────────────────┘  │
│  (Public Subnet)      └──────────┘         (Private Subnet)    │
└────────────────────────────────────────────────────────────────┘
```

Key component interactions:
1. Client requests are received by the Application Load Balancer in public subnets
2. ALB routes traffic to ECS tasks running in private subnets
3. ECS tasks fetch container images and publish logs to CloudWatch
4. Auto-scaling adjusts task count based on CPU/memory metrics
5. NAT Gateway enables outbound internet access for private subnets
6. IAM roles control permissions for task execution and container access
7. Security groups manage inbound/outbound traffic rules

## Infrastructure

![Infrastructure diagram](./docs/infra.svg)

### VPC Resources
- VPC with DNS support and hostnames enabled
- Internet Gateway for public subnet access
- NAT Gateway for private subnet outbound traffic
- Public and private subnets across multiple AZs
- Route tables for traffic management

### ECS Resources
- ECS Cluster with Container Insights
- Task Definition with CPU and memory specifications
- ECS Service with desired task count and auto-scaling
- Application Load Balancer with target groups
- CloudWatch Log Groups for container logs

### IAM Resources
- ECS Task Execution Role for container operations
- ECS Task Role for application permissions
- Custom policies for CloudWatch Logs access

## Deployment

### Prerequisites
- S3 bucket for Terraform state
- DynamoDB table for state locking
- AWS credentials with appropriate permissions

### Deployment Steps
1. Initialize Terraform backend
2. Configure environment variables
3. Apply Terraform configuration
4. Verify ECS service deployment
5. Configure CI/CD pipeline

### Environment Configurations
- Development: Single AZ, minimal resources
- Staging: Multi-AZ, moderate resources
- Production: Multi-AZ, high availability

### Monitoring Setup
- CloudWatch metrics for ECS tasks
- Container Insights for detailed monitoring
- ALB access logs for traffic analysis
- Auto-scaling metrics and alarms