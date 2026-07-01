# AWS Multi-VPC Infrastructure

Production-grade dual-VPC AWS architecture with a Golden AMI build pipeline. App servers live in private subnets, reachable only through a Bastion host via Transit Gateway. Built with Packer + Terraform.

## Architecture

```
Internet
  │
  ├──▶ Bastion VPC (192.168.0.0/16)
  │       │
  │    Bastion EC2 (public subnet)
  │       │
  │    Transit Gateway ◀──────────────────────┐
  │                                           │
  └──▶ App VPC (172.32.0.0/16)               │
          │                                   │
       ALB (public subnet)                    │
          │                                   │
       ASG → EC2 ×2-4 (private subnets) ─────┘
          (Golden AMI: Apache2 + CW Agent + SSM)
```

## Tech Stack

- **AMI Pipeline:** Packer (Ubuntu 22.04 → Golden AMI)
- **IaC:** Terraform (9 modules)
- **Networking:** Transit Gateway, VPC Peering routes, NAT Gateway
- **Compute:** EC2 Auto Scaling Group (min 2 / max 4), Launch Template
- **Load Balancing:** Application Load Balancer
- **Observability:** CloudWatch Agent, SSM Parameter Store config
- **Access:** SSM Session Manager (no open SSH port needed)

## Terraform Modules

```
terraform/modules/
├── vpc_public/         # Bastion VPC — IGW, public subnet, route table
├── vpc_private/        # App VPC — 4 subnets (2 public, 2 private), NAT GW
├── security-groups/    # bastion_sg, alb_sg, app_sg
├── transit-gateway/    # TGW + attachments + cross-VPC routes
├── iam/                # EC2 instance role (SSM + CloudWatch policies)
├── bastion/            # Bastion EC2 instance
├── launch-template/    # App LT using Golden AMI
├── cloudwatch/         # CW Agent config pushed via SSM Parameter Store
└── asg/                # Auto Scaling Group attached to ALB
```

## Packer Golden AMI

```bash
cd packer/
packer init .
packer build golden-ami.pkr.hcl
```

Installs on Ubuntu 22.04:
- Apache2 (web server)
- CloudWatch Agent (metrics + logs)
- SSM Agent (remote access, patch management)

## Deploy

```bash
# 1. Build the AMI first
cd packer/
packer build golden-ami.pkr.hcl
# Note the AMI ID from output

# 2. Deploy infrastructure
cd ../terraform/
terraform init
terraform apply
```

## Security Design

- App EC2 instances have **no public IP** — only reachable from Bastion via Transit Gateway
- ALB is the only public entry point for application traffic
- EC2 IAM role is least-privilege: SSM + CloudWatch only
- No long-lived SSH keys required — use SSM Session Manager instead

## Key Concepts

- **Golden AMI pattern** — bake dependencies into AMI at build time, not at boot time
- **Transit Gateway** — scalable hub-and-spoke networking between VPCs
- **CloudWatch Agent via SSM** — centralized config delivery without manual file editing
