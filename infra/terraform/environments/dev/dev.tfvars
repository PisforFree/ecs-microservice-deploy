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


alb_name      = "micro-dev-alb"   # <-- your existing ALB name
tg_name       = "micro-dev-tg-80" # <-- your existing TG name
listener_port = 80

ecr_repo_uri = "803767876973.dkr.ecr.us-east-2.amazonaws.com/microservice"
image_digest = "sha256:c56728b0cf8efc961fd6d3abf1db620822bbb7c4faa962f2be54d867e4f69775"

# Existing NAT & Private RTB you gave me earlier
existing_private_route_table_id = "rtb-0cfd187c223fc7632"
existing_nat_gateway_id         = "nat-06063c10377fba6a0"


ecs_cluster_name        = "micro-dev-cluster"
ecs_service_name        = "micro-dev-svc"
alb_arn_suffix          = "app/micro-dev-alb/8e1ed4b4b414ef9f/1aafdbdd396b1319"
target_group_arn_suffix = "targetgroup/micro-dev-tg-80/9f9bbaf61d8f7551"

sns_topic_arn = "arn:aws:sns:us-east-2:803767876973:micro-dev-alerts-use2"

