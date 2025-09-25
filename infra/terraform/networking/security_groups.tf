# ALB SG: allow 80/443 from anywhere; egress all
resource "aws_security_group" "alb" {
  name        = "${var.project_prefix}-${var.env}-alb-sg"
  description = "ALB ingress 80/443 from world"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_prefix}-${var.env}-alb-sg" }
}

# ECS Service SG: allow only from ALB SG on app port (e.g., 3000)


resource "aws_security_group" "ecs_service" {
  name        = "${var.project_prefix}-${var.env}-ecs-svc-sg"
  description = "ECS tasks receive traffic from ALB only"
  vpc_id      = aws_vpc.this.id

  ingress {
    description     = "From ALB"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  # Egress all (Fargate tasks need egress to reach the Internet via NAT)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_prefix}-${var.env}-ecs-svc-sg" }
}
