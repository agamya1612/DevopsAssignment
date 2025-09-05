variable "project"        { default = "webapp" }
variable "region"         { description = "AWS region" }
variable "azs"            { type = list(string) }
variable "vpc_cidr"       { default = "10.0.0.0/16" }
variable "public_subnets" { type = list(string) }
variable "private_subnets"{ type = list(string) }

variable "allowed_ssh_cidr" { description = "Your IP for bastion SSH access" }
variable "key_pair_name"    { description = "EC2 key pair name" }

variable "instance_type" { default = "t3.micro" }
variable "asg_min"       { default = 2 }
variable "asg_max"       { default = 4 }
variable "asg_desired"   { default = 2 }

variable "db_name"       { default = "appdb" }
variable "db_username"   { default = "appuser" }
variable "db_password"   { sensitive = true }
variable "db_instance_class" { default = "db.t3.micro" }
variable "db_allocated_storage" { default = 20 }
