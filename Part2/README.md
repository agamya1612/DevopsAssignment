# Part 2 – Application Deployment (Node.js + Docker + ECS Fargate)

This part builds and deploys a simple **Node.js (Express)** app containerized with Docker, running on **ECS Fargate**, connected to the RDS database from Part 1.

---

## 📂 Structure

---

## 🟢 App

**Endpoints:**
- `/` → hello message
- `/items` → test query from RDS
- `/health` → health check (200 OK)

---

## ⚙️ Prerequisites
- Docker installed
- Terraform >= 1.5
- AWS CLI configured (`aws configure`)
- AWS Account with permissions for ECS, ECR, Secrets Manager, IAM

---

## 🚀 Steps to Deploy

### 1. Build & push Docker image
```bash
cd app
docker build -t nodeapp .
aws ecr get-login-password --region <region> \
  | docker login --username AWS --password-stdin <account_id>.dkr.ecr.<region>.amazonaws.com

# Tag & push
docker tag nodeapp:latest <account_id>.dkr.ecr.<region>.amazonaws.com/webapp-repo:latest
docker push <account_id>.dkr.ecr.<region>.amazonaws.com/webapp-repo:latest
