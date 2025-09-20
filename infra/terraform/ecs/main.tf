#############################
# ECS service (public subnets + public IP)
#############################

locals {
  ecs_service_name = "${var.project_prefix}-${var.env}-ecs-service"
}

# Security group for the ECS service
resource "aws_security_group" "app" {
  name        = "${var.project_prefix}-${var.env}-svc-sg"
  description = "Security group for ECS Fargate service"
  vpc_id      = module.networking.vpc_id

  # Egress: allow all (service reaches internet via public IP)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_prefix}-${var.env}-svc-sg"
    Project = var.project_prefix
    Env     = var.env
    Managed = "terraform"
  }
}

# Only allow HTTP from the ALB security group to the service
# (Assumes your ALB module/export is module.alb.sg_id; if your identifier differs,
#  replace module.alb.sg_id with the correct SG id.)
resource "aws_security_group_rule" "alb_to_app_http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app.id
  source_security_group_id = module.alb.sg_id
}

# ECS service: run in public subnets and assign a public IP
resource "aws_ecs_service" "app" {
  name            = local.ecs_service_name
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  enable_execute_command = true

  # —— KEY CHANGE for Step 11 ——
  network_configuration {
    subnets          = module.networking.public_subnet_ids   # use public subnets
    security_groups  = [aws_security_group.app.id]
    assign_public_ip = true                                   # give tasks a public IP
  }

  # If you front this with an ALB Target Group:
  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = aws_ecs_task_definition.app.family
    container_port   = 80
  }

  deployment_controller { type = "ECS" }

  lifecycle {
    # keep deployments from flapping on desired_count tweaks
    ignore_changes = [desired_count]
  }

  tags = {
    Name    = local.ecs_service_name
    Project = var.project_prefix
    Env     = var.env
    Managed = "terraform"
  }
}

