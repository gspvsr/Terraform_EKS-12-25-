terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket         = "remote-state-backend32"
    key            = "terraform/EKS.tf"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
    region         = "us-east-1"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws-region
}
