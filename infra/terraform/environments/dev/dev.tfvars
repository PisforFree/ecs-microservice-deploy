# environments/dev/dev.tfvars

region         = "us-east-2"
project_prefix = "micro"
env            = "dev"

# --- Existing VPC + Subnets + SGs ---
vpc_id                 = "vpc-xxxxxxxxxxxxxxxxx"
alb_subnet_ids         = ["subnet-aaaaaaaaaaaaaaa", "subnet-bbbbbbbbbbbbb"]
alb_security_group_ids = ["sg-xxxxxxxxxxxxxxxxx"]

ecs_private_subnet_ids        = ["subnet-ccccccccccccccc", "subnet-ddddddddddddd"]
ecs_service_security_group_id = "sg-yyyyyyyyyyyyyyyyy"

# --- Day-6 Image wiring ---
# Replace these with real values at runtime:
ecr_repo_uri = "8037XXXXXXXX.dkr.ecr.us-east-2.amazonaws.com/microservice"

alb_name       = "micro-dev-alb"    # <-- your existing ALB name
tg_name        = "micro-dev-tg-80"  # <-- your existing TG name
listener_port  = 80
