# Part 4 - Monitoring & Logging

## Deploy

1. Initialize Terraform
   terraform init

2. Plan
   terraform plan -out=tfplan

3. Apply
   terraform apply tfplan

## Verify

- CloudWatch Dashboard: "my-app-dashboard"
- Log Group: /ecs/<service-name>
- Alarms: ECS CPU/Memory, RDS Connections
- SNS notifications sent to configured email

## Custom Metrics

- Run scripts/publish_custom_metric.py to send ActiveUsers metric
