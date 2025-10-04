############################################
# ECS task trust policy (MISSING before)
############################################
data "aws_iam_policy_document" "ecs_tasks_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

############################################
# Task EXECUTION role (pull from ECR, write logs)
############################################
resource "aws_iam_role" "task_execution_role" {
  name               = "${var.project_prefix}-${var.env}-ecs-task-exec"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_role.json
  tags = {
    project = var.project_prefix
    env     = var.env
    role    = "ecs-task-execution"
  }
}

# AWS managed policies commonly attached to execution role
resource "aws_iam_role_policy_attachment" "task_exec_managed" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# (Optional but used in your project history)
resource "aws_iam_role_policy_attachment" "task_exec_ecr_readonly" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Extra logs write permissions (safe for dev; scope down later if desired)
data "aws_iam_policy_document" "task_exec_logs" {
  statement {
    sid    = "ECSExecWriteCloudWatchLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "task_exec_logs" {
  name        = "${var.project_prefix}-${var.env}-ecs-task-exec-logs"
  description = "Allow ECS task execution role to write to CloudWatch Logs"
  policy      = data.aws_iam_policy_document.task_exec_logs.json
}

resource "aws_iam_role_policy_attachment" "task_exec_logs_attach" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = aws_iam_policy.task_exec_logs.arn
}

############################################
# Task ROLE (your app’s runtime permissions)
############################################
resource "aws_iam_role" "task_role" {
  name               = "${var.project_prefix}-${var.env}-ecs-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_role.json
  tags = {
    project = var.project_prefix
    env     = var.env
    role    = "ecs-task"
  }
}

/*
  Attach app-specific permissions here if/when needed, e.g.:

resource "aws_iam_policy" "app_policy" {
  name   = "${var.project_prefix}-${var.env}-app-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = []
  })
}

resource "aws_iam_role_policy_attachment" "task_role_app_attach" {
  role       = aws_iam_role.task_role.name
  policy_arn = aws_iam_policy.app_policy.arn
}
*/
