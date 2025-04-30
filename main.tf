###################################################
# Main Terraform configuration file
###################################################

# Call the networking module to set up VPC and subnets
module "networking" {
  source = "./modules/networking"

  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  availability_zones  = var.availability_zones
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

# Call the IAM module to set up necessary roles and policies
module "iam" {
  source = "./modules/iam"

  environment = var.environment
  project     = var.project_name
}

# Call the ECS module to set up the ECS cluster, service, and task definition
module "ecs" {
  source = "./modules/ecs"

  environment      = var.environment
  project_name     = var.project_name
  region           = var.region
  vpc_id           = module.networking.vpc_id
  public_subnets   = module.networking.public_subnet_ids
  private_subnets  = module.networking.private_subnet_ids
  ecs_service_name = var.ecs_service_name
  container_name   = var.container_name
  container_image  = var.container_image
  container_port   = var.container_port
  cpu              = var.cpu
  memory           = var.memory
  desired_count    = var.desired_count
  execution_role_arn = module.iam.ecs_execution_role_arn
  task_role_arn    = module.iam.ecs_task_role_arn
}