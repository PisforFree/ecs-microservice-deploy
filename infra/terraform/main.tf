locals {
  project_prefix = var.project_prefix
  env            = var.env
  region         = var.region
}

# --- REMOVE or COMMENT OUT networking creation, since ALB is in an EXISTING VPC ---
# module "networking" {
#   source = "./networking"
#   project_prefix       = local.project_prefix
#   env                  = local.env
#   region               = local.region
#   vpc_cidr             = "10.0.0.0/16"
#   azs                  = ["us-east-2a", "us-east-2b"]
#   public_subnet_cidrs  = ["10.0.0.0/20", "10.0.16.0/20"]
#   private_subnet_cidrs = ["10.0.32.0/20", "10.0.48.0/20"]
#   app_port             = 80
# }

# ALB pinned to EXISTING VPC + EXISTING subnets/SGs (from dev.tfvars)
module "alb" {
  source = "./alb"

  project_prefix         = var.project_prefix
  env                    = var.env
  vpc_id                 = var.vpc_id
  alb_subnet_ids         = var.alb_subnet_ids
  alb_security_group_ids = var.alb_security_group_ids

  app_port          = 80
  health_check_path = "/"
}

# ECS must also use the EXISTING VPC’s private subnets + ECS service SG
module "ecs" {
  source = "./ecs"

  project_prefix = var.project_prefix
  env            = var.env
  region         = var.region

  # 🔑 image inputs (new)
  ecr_repo_uri = var.ecr_repo_uri
  image_digest = var.image_digest

  # 🔒 networking in the SAME (existing) VPC as the ALB
  private_subnet_ids            = var.ecs_private_subnet_ids
  ecs_service_security_group_id = var.ecs_service_security_group_id

  # ALB target group from the ALB module
  target_group_arn = module.alb.tg_arn
}

