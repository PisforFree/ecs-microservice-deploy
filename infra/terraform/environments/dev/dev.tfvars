# environments/dev/dev.tfvars

region         = "us-east-2"
project_prefix = "micro"
env            = "dev"

# --- Existing VPC + Subnets + SGs ---
vpc_id                 = "vpc-06ea32c95833148f2"
alb_subnet_ids         = ["subnet-03c932e9f9306e3a4", "subnet-04863685420d63b92"]
alb_security_group_ids = ["sg-0453aac7914b0d2e3"]

ecs_private_subnet_ids        = ["subnet-0cb937fb5a2ff2457", "subnet-06c96b155527807d1"]
ecs_service_security_group_id = "sg-0e34f9dc02d29cb77"


# --- Day-6 Image wiring ---
# Replace these with real values at runtime:
ecr_repo_uri = "8037XXXXXXXX.dkr.ecr.us-east-2.amazonaws.com/microservice"

alb_name      = "micro-dev-alb"   # <-- your existing ALB name
tg_name       = "micro-dev-tg-80" # <-- your existing TG name
listener_port = 80
