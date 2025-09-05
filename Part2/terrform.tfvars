region = "ap-south-1"

subnets         = ["subnet-00a40a6b4c23fdeb0", "subnet-045366da6c3bb23cb"] # replace with your private subnets
security_groups = ["sg-0f36e8bde05549768"]                     # replace with ECS SG
target_group_arn = "arn:aws:elasticloadbalancing:ap-south-1:116555270265:targetgroup/webapp-fargate-tg/2c6d4480a17d8996" # ALB TG from Part 1
alb_listener     = "arn:aws:elasticloadbalancing:ap-south-1:116555270265:loadbalancer/app/webapp-alb/f8db1225c65f181c" # ALB Listener from Part 1

db_host     = "webapp-postgres.c1iayeso0jg2.ap-south-1.rds.amazonaws.com"
db_name     = "appdb"
db_user     = "appuser"
db_password = "ChangeMe#1234"

