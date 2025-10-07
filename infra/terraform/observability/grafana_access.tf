# Discover your IAM Identity Center instance (in us-east-1)
data "aws_ssoadmin_instances" "this" {
  provider = aws.sso
}

locals {
  identity_store_id = one(data.aws_ssoadmin_instances.this.identity_store_ids)
}

variable "grafana_admins_group_name" {
  type    = string
  default = "GrafanaAdmins"
}

# Look up the SSO group by DisplayName using the non-deprecated syntax
data "aws_identitystore_group" "grafana_admins" {
  provider         = aws.sso
  identity_store_id = local.identity_store_id

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = var.grafana_admins_group_name
    }
  }
}

resource "aws_grafana_role_association" "admins" {
  workspace_id = aws_grafana_workspace.this.id
  role         = "ADMIN"
  group_ids    = [data.aws_identitystore_group.grafana_admins.group_id]
}
