variable "region"         { description = "AWS region for all resources"; type = string }
variable "project_prefix" { description = "Resource name prefix";        type = string }
variable "env"            { description = "Deployment environment";      type = string }
variable "image_uri"      { description = "ECR image URI (digest)";      type = string }