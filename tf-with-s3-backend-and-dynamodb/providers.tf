terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.21.0"
    }
  }
  backend "s3" {
    bucket = "ath-142002-ath"
    region = "ap-south-1"
    encrypt = true
    key = "dev/terraform.tfstate"
    dynamodb_table = "terraform-state-lock"
  }
}

provider "aws" {
  region = var.region
}