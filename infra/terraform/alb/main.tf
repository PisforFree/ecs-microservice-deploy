terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

locals {
  name = "${var.project_prefix}-${var.env}"
  tags = {
    Project = var.project_prefix
    Env     = var.env
    Managed = "terraform"
  }
}

# ----------------------------
# Application Load Balancer
# ----------------------------
resource "aws_lb" "this" {
  name               = "${local.name}-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids
  idle_timeout       = 60

  tags = merge(local.tags, { Name = "${local.name}-alb" })
}

# ----------------------------
# Target Group (ip targets for Fargate)
# ----------------------------
resource "aws_lb_target_group" "app_tg" {
  name        = "${local.name}-tg"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    matcher             = "200-399"
    path                = var.health_check_path
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 5
    interval            = 30
    timeout             = 5
  }

  deregistration_delay = var.deregistration_delay

  tags = merge(local.tags, { Name = "${local.name}-tg" })
}

# ----------------------------
# HTTP Listener :80 -> TG
# ----------------------------
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }

  tags = merge(local.tags, { Name = "${local.name}-http-listener" })
}

# (Optional) HTTPS :443 with ACM can be added later
