# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Purpose

AWS VPC architecture built with Packer + Terraform. Produces a Golden AMI (Ubuntu 22.04 + Apache2 + CloudWatch Agent) and deploys a full multi-VPC infrastructure with Auto Scaling behind an Application Load Balancer.

## Architecture

```
Internet
    │
    ├─────────────────────────────────────────┐
    ▼                                         ▼
Bastion VPC (192.168.0.0/16)        App VPC (172.32.0.0/16)
├── public subnet 192.168.1.0/24    ├── public subnet 172.32.1.0/24 (ALB)
│   └── Bastion EC2 (t3.micro)      ├── public subnet 172.32.2.0/24 (NAT GW)
│       bastion_sg: port 22         ├── private subnet 172.32.3.0/24 (App EC2)
│                                   └── private subnet 172.32.4.0/24 (App EC2)
└── IGW                                 alb_sg: 80/443 | app_sg: 80+22
         │                                        │
         └──────── Transit Gateway ───────────────┘
```

**Traffic flow:**
- `Internet → IGW → ALB → app_sg (port 80)`
- `SSH → Bastion → TGW → app servers (port 22)`
- `App EC2 → NAT GW → Internet` (outbound only)

## Terraform Modules

| Module | Purpose |
|--------|---------|
| `vpc_public` | Bastion VPC, subnet, IGW, route table |
| `vpc_private` | App VPC, 4 subnets, IGW, NAT GW, EIP, route tables |
| `security-groups` | bastion_sg, alb_sg, app_sg |
| `transit-gateway` | TGW + attachments + routes between VPCs |
| `iam` | EC2 role with SSM + CloudWatch policies |
| `bastion` | Bastion EC2 in vpc_public |
| `launch-template` | App EC2 template with Golden AMI + user_data |
| `cloudwatch` | SSM Parameter `/cloudwatch/config` for CloudWatch Agent |
| `alb` | ALB + target group + HTTP listener |
| `asg` | Auto Scaling Group min 2 / max 4, attached to ALB |

## Packer Commands

```bash
# Initialize plugins (required once after clone)
packer init packer/

# Validate
packer validate -var-file=packer/golden-ami.pkrvars.hcl packer/

# Build Golden AMI
packer build -var-file=packer/golden-ami.pkrvars.hcl packer/
```

## Terraform Commands

```bash
cd terraform/

# Initialize
terraform init

# Plan
terraform plan

# Apply
terraform apply

# Destroy (run when not working to avoid costs)
terraform destroy
```

## AWS Credentials

```bash
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
export AWS_DEFAULT_REGION=us-east-2
```

## Cost Warning

NAT Gateway costs ~$0.05/hour (~$1.20/day). Run `terraform destroy` when not in use.

## Sensitive Files (gitignored)

- `packer/golden-ami.pkrvars.hcl` — Packer variables with secrets
- `terraform/.terraform/` — local provider cache
- `terraform/terraform.tfstate` — infrastructure state (contains sensitive data)
