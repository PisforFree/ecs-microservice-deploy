########################################
# READ EXISTING ALB / TG / LISTENER
########################################

# Existing ALB by name
data "aws_lb" "this" {
  name = var.alb_name
}

# Existing Target Group by name
data "aws_lb_target_group" "app" {
  name = var.tg_name
}

# Existing HTTP listener on the ALB (e.g., :80)
data "aws_lb_listener" "http" {
  load_balancer_arn = data.aws_lb.this.arn
  port              = var.listener_port
}

########################################
# (No resource "aws_lb" or "aws_lb_target_group" here)
# Health check, subnets, SGs, etc. remain managed
# outside Terraform OR via import if you want management.
########################################
