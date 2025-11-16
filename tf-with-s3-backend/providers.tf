terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.21.0"
    }
  }
  backend "s3" {
    region = "ap-south-1"
    bucket = "ath-142002-ath"
    key = "dev/terraform.tfstate"
    encrypt = true
    use_lockfile = true
  }
}

provider "aws" {
  region = var.region
}