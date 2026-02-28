terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket         = "pgagi-terraform-state-550869128317"
    key            = "Prod/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "pgagi-terraform-locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}