# Part 5 - Advanced Deployment & RDS Backups

## Deploy Blue-Green ECS

1. Ensure ECS cluster/service and ALB target groups exist
2. Initialize Terraform
   terraform init
3. Plan
   terraform plan -out=tfplan
4. Apply
   terraform apply tfplan

## RDS Backups

- Automated backups enabled with retention = 7 days (default)
- Backup window: 03:00-04:00 UTC
- Multi-AZ enabled for HA

## Outputs

- CodeDeploy app and deployment group names
- RDS instance endpoint
