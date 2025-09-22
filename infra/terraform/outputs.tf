@'
// Placeholder outputs; fill as resources are added.
output "env" {
  value = var.env
}
'@ | Out-File -FilePath infra/terraform/outputs.tf -Encoding UTF8
