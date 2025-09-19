# Harmless lookups (no resources created)
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

# (Nothing else yet. Real modules/resources come in Task 2+)

module "networking" {
  source         = "./networking"
  region         = var.region
  project_prefix = var.project_prefix
  env            = var.env

  # optional overrides (else defaults are used)
  # vpc_cidr              = "10.20.0.0/16"
  # azs                   = ["us-east-2b", "us-east-2c"]
  # public_subnet_cidrs   = ["10.20.1.0/24", "10.20.2.0/24"]
  # private_subnet_cidrs  = ["10.20.11.0/24","10.20.12.0/24"]
}

module "ecs" {
  source         = "./ecs"
  region         = var.region
  project_prefix = var.project_prefix
  env            = var.env

  # Optional tweak for cost experiments (not recommended for first run)
  # use_fargate_spot_weight = 0
}

module "alb" {
  source         = "./alb"
  region         = var.region
  project_prefix = var.project_prefix
  env            = var.env

  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  alb_sg_id         = module.networking.alb_sg_id

  # Keep this consistent with your service containerPort
  app_port = 3000

  # If your app has a health endpoint like /healthz, set it here
  # health_check_path = "/healthz"
}

module "ecs_service" {
  source         = "./ecs_service"
  region         = var.region
  project_prefix = var.project_prefix
  env            = var.env

  private_subnet_ids = module.networking.private_subnet_ids
  ecs_tasks_sg_id    = module.networking.ecs_tasks_sg_id
  target_group_arn   = module.alb.tg_arn

  ecs_cluster_name        = module.ecs.ecs_cluster_name
  task_execution_role_arn = module.ecs.task_execution_role_arn
  task_role_arn           = module.ecs.task_role_arn

  # IMPORTANT: set this to your ECR image *digest* URI
  # Example: 123456789012.dkr.ecr.us-east-2.amazonaws.com/microservice@sha256:abc123...
  image_uri = var.image_uri

  log_group_name    = module.ecs.app_log_group_name
  log_stream_prefix = "ecs"

  app_port      = 3000
  cpu           = 256
  memory        = 512
  desired_count = 1

  # Optional environment variables for the container
  # env_vars = {
  #   NODE_ENV = "production"
  # }
}
