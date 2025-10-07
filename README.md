# 🚀 ECS Fargate Microservices Deployment (GitOps + Observability)

## 📘 Overview
This project demonstrates an **enterprise-style CI/CD pipeline** and infrastructure deployment for a containerized microservice on **AWS ECS Fargate**, built entirely with **Terraform** and automated through **GitHub Actions** using **OIDC authentication** (no static AWS keys).  
It follows GitOps best practices with separate repositories for application and infrastructure code, enforcing security, automation, and reproducibility.

The solution includes:
- Modular Terraform IaC for VPC, ECS Fargate, ALB, IAM, and observability
- GitHub Actions CI/CD pipelines with OIDC-based authentication
- End-to-end observability via CloudWatch + Amazon Managed Grafana
- Cost guardrails and IAM least-privilege governance

---

## 🏗️ Architecture Overview

### AWS Components
| Layer | Services & Configuration |
|-------|---------------------------|
| **Networking** | VPC (`vpc-06ea32c95833148f2`) with 2 public + 2 private subnets, NAT Gateway (`nat-06063c10377fba6a0`), and segmented security groups (ALB 80/443 inbound; ECS tasks only from ALB SG). |
| **Compute & Containers** | ECS Cluster `micro-dev-ecs` running Fargate Service `micro-dev-service`. Tasks pull images from ECR and log to CloudWatch. |
| **Load Balancing** | Application Load Balancer (ALB) front-end with target group `micro-dev-tg-80`; health checks on `/`; returns HTTP 200 OK. |
| **Storage & State** | Terraform backend via encrypted S3 bucket + DynamoDB table for state locking. |
| **Monitoring & Logs** | CloudWatch log groups (`/ecs/micro-dev`, `/ecs/micro-dev-app`), Container Insights metrics, Managed Grafana dashboards. |
| **Governance & Security** | IAM group `DevOpsEngineers` (MFA enforced), least-privilege automation roles for ECR push and Terraform deploy, AWS Budgets $50 limit with SNS alerts. |

🗺️ *Architecture Diagram*  
*(Insert `architecture_diagram.png` illustrating VPC + ALB + ECS + GitHub CI/CD + CloudWatch/Grafana flow.)*

---

## ⚙️ CI/CD Pipeline — GitOps Workflow

### Repositories
| Repo | Purpose |
|------|----------|
| **ecs-microservice-app** | Contains microservice source, Dockerfile, and CI workflow to build, scan, and push images to ECR. |
| **ecs-microservice-deploy** | Contains Terraform infrastructure modules and workflow to apply infra changes via PR approval and merge. |

### Workflow Summary
1. **App Repo (CI pipeline)**  
   - Runs tests and Trivy scan.  
   - Builds Docker image and pushes to ECR (with SHA digest).  
   - Automatically creates a PR in the deploy repo to update `app.auto.tfvars` with the new digest.
2. **Deploy Repo (CD pipeline)**  
   - On PR → `terraform plan` (run by `GitHubTerraformDeployRole`).  
   - On merge → `terraform apply` to deploy updated image digest to ECS Fargate.  
   - ALB verifies health checks and serves the new version.  

🧩 *CI/CD Flow Diagram*  
*(Insert `cicd_workflow.png` showing App → Deploy → ECS → ALB cycle.)*

---

## 🔒 Security & IAM Design

| Type | Role / Group | Description |
|------|---------------|-------------|
| **Human Access** | `DevOpsEngineers` IAM Group + policy `DevOpsReadOnlyPlus` | Read-only and safe operations policy (MFA enforced). |
| **Automation** | `GitHubECRPushRole` | Allows CI workflow to push images to ECR. |
| | `GitHubTerraformDeployRole` | Allows CD workflow to run Terraform plan/apply with least privilege. |
| **Task Roles** | ECS task execution role (`micro-dev-ecs-task-exec`) + task role | Limited to ECR read + CloudWatch logs. |
| **Terraform Backend** | Encrypted S3 bucket + DynamoDB lock table `tf-locks` | Prevents state corruption and enforces team coordination. |

All automation uses **OIDC-based assume-role** authentication—no long-lived AWS keys in GitHub.

---

## 📊 Observability & Monitoring

- **CloudWatch Logs** — `/ecs/micro-dev` and `/ecs/micro-dev-app` store container stdout/stderr.  
- **Container Insights** — CPU, memory, network, and task metrics enabled for ECS cluster and ALB.  
- **Managed Grafana Workspace** — `micro-dev-grafana` integrated via AWS SSO (GrafanaAdmins group).  
- **Unified Dashboard** — visualizes ECS CPU/Memory/Tasks, ALB latency, 5xx errors, and request count.  
- **Cost Controls** — AWS Budget ($50/month) with 80% and 100% SNS threshold alerts (`micro-dev-alerts-use1`).  

---

## ✅ Results & Deliverables

| Category | Status | Notes |
|-----------|---------|-------|
| **Networking + ECS** | ✅ Complete | Private subnets with NAT egress verified. ALB returns 200 OK. |
| **CI/CD Automation** | ✅ Complete | PR → Plan, Merge → Apply flow validated. |
| **IAM Security** | ✅ Complete | OIDC roles, MFA enforced, least privilege confirmed. |
| **Logging & Observability** | ✅ Complete | Logs and metrics streaming to CloudWatch + Grafana. |
| **Cost Guardrails** | ✅ Complete | Budget and SNS alerts tested successfully. |

---

## 🧩 Repository Structure

ecs-microservice-app/
├── app/
├── Dockerfile
├── .dockerignore
└── .github/workflows/ci.yml

ecs-microservice-deploy/
├── infra/terraform/
│ ├── networking/
│ ├── iam/
│ ├── ecr/
│ ├── ecs/
│ ├── observability/
│ ├── providers.tf
│ ├── backend.tf
│ ├── variables.tf
│ ├── outputs.tf
│ └── main.tf
├── environments/dev/
│ ├── dev.tfvars
│ └── app.auto.tfvars
└── .github/workflows/plan_apply.yml


---

## 🧠 Lessons Learned
- **IAM role granularity** matters: tight policies reduce risk while enabling automation.  
- **NAT Gateway connectivity** is essential for Fargate tasks to pull images from ECR.  
- **CloudWatch log groups** must exist before ECS launches tasks or logs will fail to initialize.  
- **Grafana + AWS SSO** simplifies secure observability without hard-coded credentials.  
- **GitOps model** ensures every change is traceable and reversible via Git history.

---

## 📸 Screenshots
*(Replace placeholders with actual images)*
- `screenshots/alb_200_ok.png` — ALB endpoint response 200 OK  
- `screenshots/ecs_service_running.png` — ECS service “Running”  
- `screenshots/cloudwatch_logs.png` — Active log stream  
- `screenshots/grafana_dashboard.png` — ECS + ALB metrics dashboard  
- `screenshots/aws_budget_alert.png` — Budget SNS notification  

---

## 🧾 Future Enhancements (Optional)
1. **HTTPS + Custom Domain** (ACM cert, Route 53, ALB 443 listener).  
2. **ECS Auto Scaling** based on CPU/Memory target tracking.  
3. **Rollback Automation** (Lambda trigger on failed deploy).  
4. **Alerting & Runbook** finalization (ECS task crash / ALB 5xx).  
5. **Security Hardening** — log retention + tight task role permissions.  

---

## 📜 License
MIT License – for demonstration and educational use only.

---

🏁 Project Closure Summary
✅ Final Project Status

This repository represents a fully deployed, tested, and decommissioned AWS ECS Fargate microservices environment with automated CI/CD and observability.
All infrastructure was provisioned via Terraform and automated through GitHub Actions using OIDC authentication (no static credentials).
End-to-end validation confirmed working service health, observability dashboards, and cost guardrails.

Category	Status	Notes
ECS Cluster + Service	✅ Destroyed	Verified healthy before teardown
VPC, ALB, NAT Gateway	✅ Destroyed	Confirmed via Terraform plan/destroy
CloudWatch + Grafana Workspace	✅ Deleted	Observability validated prior to teardown
ECR Repositories	✅ Deleted	All images removed
IAM Roles & Policies	✅ Deleted	GitHub OIDC, deploy, and task roles removed
IAM Groups / Users	✅ Deleted	DevOpsEngineers group retired
SNS / Budgets	✅ Deleted	$50 budget and alerts cleaned up
Terraform Backend (S3 + DynamoDB)	♻️ Retained	Preserved for reuse in future projects
GitHub Workflows	✅ Archived	Apply disabled via repo variable guard
Branches	✅ Cleaned	Only main branch remains
🧱 Artifacts Archived

The following records are preserved under the artifacts/
 folder:

terraform-outputs.json — final state outputs snapshot

terraform-state-list.txt — resource list prior to teardown

These serve as evidence of infrastructure completion and teardown validation.

🔄 Reusable Components

Terraform backend (S3 + DynamoDB) can be reused for future IaC projects by simply updating the backend key path and IAM role ARNs.

Project structure (modules, CI/CD workflow) can serve as a reference architecture for future ECS, EKS, or serverless deployments.

💰 Cost & Security Posture

No active ECS, ALB, NAT, or Grafana resources remain — cost reduced to near zero.

IAM and CI/CD roles follow least-privilege principles.

Only S3 + DynamoDB backend resources persist (< $0.10/mo estimated).

📘 Lessons Learned

Validating networking (NAT, subnets, security groups) is critical for ECS task health.

Implementing OIDC for GitHub → AWS authentication eliminates credential risks.

Centralizing logs in CloudWatch simplifies observability and debugging.

Maintaining cost guardrails via AWS Budgets ensures ongoing accountability.

🧾 Closure Statement

All infrastructure, roles, and automation pipelines were verified as successfully built, tested, and destroyed.
This repository now serves as a reference template and portfolio artifact for demonstrating real-world, enterprise-style DevOps automation on AWS.