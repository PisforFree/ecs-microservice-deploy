@'
region         = "us-east-2"
project_prefix = "micro"
env            = "dev"
'@ | Out-File -FilePath environments/dev/dev.tfvars -Encoding UTF8
