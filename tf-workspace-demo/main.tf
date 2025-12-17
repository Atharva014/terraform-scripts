resource "aws_s3_bucket" "demo" {
  bucket = "${terraform.workspace}-demo-bucket-${random_string.suffix.result}"
  
  tags = {
    Name        = "${terraform.workspace}-bucket"
    Environment = terraform.workspace
  }
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}