resource "aws_ecs_task_definition" "app" {
  family                   = "${var.project_prefix}-${var.env}-td"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  # IAM roles
  execution_role_arn = aws_iam_role.task_execution_role.arn
  task_role_arn      = aws_iam_role.task_role.arn

  # Container definition (digest-pinned image + CloudWatch logs)
  container_definitions = jsonencode([
    {
      name      = "${var.project_prefix}-${var.env}-app"
      image     = "${var.ecr_repo_uri}@${var.image_digest}" # <- digest form
      essential = true

      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.log_group_name
          awslogs-region        = var.region
          awslogs-stream-prefix = var.log_stream_prefix
          mode                  = "non-blocking"
          max-buffer-size       = "25m"
        }
      }
    }
  ])

  tags = {
    Project = var.project_prefix
    Env     = var.env
  }
}
