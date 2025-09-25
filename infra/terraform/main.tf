locals {
  project_prefix = var.project_prefix
  env            = var.env
  region         = var.region
}

module "networking" {
  source = "./networking"

  project_prefix       = local.project_prefix
  env                  = local.env
  region               = local.region
  vpc_cidr             = "10.0.0.0/16"
  azs                  = ["us-east-2a", "us-east-2b"]
  public_subnet_cidrs  = ["10.0.0.0/20", "10.0.16.0/20"]
  private_subnet_cidrs = ["10.0.32.0/20", "10.0.48.0/20"]
  app_port             = 80
}

module "ecs" {
  source = "./ecs"

  project_prefix = var.project_prefix
  env            = var.env
  region         = var.region

  private_subnet_ids            = module.networking.private_subnet_ids
  ecs_service_security_group_id = module.networking.ecs_service_security_group_id
  target_group_arn              = module.alb.tg_arn
}

module "alb" {
  source = "./alb"

  project_prefix = var.project_prefix
  env            = var.env

  vpc_id                = module.networking.vpc_id
  public_subnet_ids     = module.networking.public_subnet_ids
  alb_security_group_id = module.networking.alb_security_group_id

  app_port          = 80        # keep in sync with ECS service
  health_check_path = "/health" # change if your app uses /status, etc.
}


