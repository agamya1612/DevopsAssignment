terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
  }
}

provider "aws" {
  region = var.region
 #  access_key = "<<Give your own access key>>"
  #  secret_key = "<<Give your own secret key>>"
}

provider "random" {
  version = "~> 3.5"
}