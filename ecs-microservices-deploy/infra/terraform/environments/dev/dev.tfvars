region         = "us-east-2"
project_prefix = "micro"
env            = "dev"
image_uri      = "803767876973.dkr.ecr.us-east-2.amazonaws.com/microservice@sha256:ec5aa10ced6cf680e972a31e953e02d976e99e355dfab221e1a6fe6b447b1635"

ecs_cluster_name = "micro-dev-ecs-cluster" # <-- replace with your real cluster name
ecs_service_name = "micro-dev-service"     # <-- replace with your real service name

min_task_count     = 1
max_task_count     = 3
cpu_target_percent = 50
scale_in_cooldown  = 120
scale_out_cooldown = 60
