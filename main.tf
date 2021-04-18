terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.32"
    }
  }

  backend "s3" {
    bucket  = "<BUCKET-NAME>"
    encrypt = "true"
    key     = "terraform.tfstate"
    region  = "us-east-1"
  }
}

data "aws_region" "current" {}

module "vpc" {
  source               = "./modules/vpc"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
  vpc_cidr             = "10.0.0.0/16"
  vpc_name             = "${var.project_prefix}-${var.environment}-vpc"

  availability_zones = {
    "0" = var.availability_zone_1
    "1" = var.availability_zone_2
    "2" = var.availability_zone_3
  }

  subnets = {
    "0" = "10.0.0.0/20"
    "1" = "10.0.16.0/20"
    "2" = "10.0.32.0/20"
  }

  private_subnets = {
    "0" = "10.0.64.0/20"
    "1" = "10.0.80.0/20"
    "2" = "10.0.96.0/20"
  }
}