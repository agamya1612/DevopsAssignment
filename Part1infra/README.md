# Part 1 – Infrastructure as Code (Terraform, AWS)

Provisions:
- VPC with **2 public + 2 private** subnets across **2 AZs**
- **Internet Gateway**, **NAT Gateway**, and **route tables**
- **Application Load Balancer** in public subnets
- **Auto Scaling Group** with **EC2 instances in private subnets**
- **RDS PostgreSQL** in private subnets
- **Security Groups** per assignment
- **Bastion host** in public subnet (SSH access into private)

## Prerequisites
- Terraform >= 1.5
- AWS CLI v2 configured
- Existing EC2 key pair name in the target region

## Quick Start

```bash

terraform init
terraform plan
terraform apply -auto-approve

#Useful outputs
terraform output

What’s Created

VPC: DNS hostnames/support enabled

Subnets: 2x public, 2x private (mapped to AZs you specify)

Routing: Public→IGW; Private→NAT

ALB: HTTP (80) listener; target group health: /

ASG: Amazon Linux 2 instances in private subnets, port 80 open from ALB only

RDS: PostgreSQL (multi-AZ optional via class & settings), private only

Bastion: Public subnet with your key pair

Security Groups:

ALB: allow 80/443 from internet

EC2: allow port 80 from ALB SG only, SSH 22 from Bastion SG only

RDS: allow 5432 from EC2 SG only

Bastion: allow 22 from your IP