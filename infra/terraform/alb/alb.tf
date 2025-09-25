############################################
# Application Load Balancer + Target Group #
############################################

# ALB (public) in the provided subnets with the provided SG
resource "aws_lb" "this" {
  name               = "${var.project_prefix}-${var.env}-alb"
  load_balancer_type = "application"
  internal           = false

  security_groups = [var.alb_security_group_id]
  subnets         = var.public_subnet_ids

  tags = {
    Name    = "${var.project_prefix}-${var.env}-alb"
    project = var.project_prefix
    env     = var.env
  }
}

# Target group for ECS Fargate tasks (IP mode).
# IMPORTANT: create_before_destroy + a unique name suffix allow safe replacement
# when changing ports (e.g., 3000 -> 80) without "ResourceInUse" errors.
resource "aws_lb_target_group" "app" {
  name        = "${var.project_prefix}-${var.env}-tg-${var.app_port}"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name    = "${var.project_prefix}-${var.env}-tg-${var.app_port}"
    project = var.project_prefix
    env     = var.env
  }
}

# HTTP listener on :80 forwarding to the TG
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
