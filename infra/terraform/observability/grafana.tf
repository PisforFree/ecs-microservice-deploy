# infra/terraform/observability/grafana.tf

# 1. Service role for Grafana to access CloudWatch
resource "aws_iam_role" "grafana_service_role" {
  name = "micro-dev-grafana-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "grafana.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# 2. Attach managed Grafana policy for CloudWatch access
resource "aws_iam_role_policy_attachment" "grafana_cloudwatch_access" {
  role       = aws_iam_role.grafana_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}

# 3. Create Grafana workspace
resource "aws_grafana_workspace" "this" {
  name                     = "micro-dev-grafana"
  account_access_type      = "CURRENT_ACCOUNT"
  authentication_providers = ["AWS_SSO"]
  permission_type          = "SERVICE_MANAGED"
  data_sources             = ["CLOUDWATCH"]
  role_arn                 = aws_iam_role.grafana_service_role.arn  # ✅ required for CURRENT_ACCOUNT

  tags = {
    project = var.project_prefix
    env     = var.env
  }
}

# 4. Outputs
output "grafana_workspace_id" {
  value = aws_grafana_workspace.this.id
}

output "grafana_endpoint" {
  value = aws_grafana_workspace.this.endpoint
}
