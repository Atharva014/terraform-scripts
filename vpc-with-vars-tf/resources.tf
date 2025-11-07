resource "aws_vpc" "vpc-label" {
  cidr_block = var.ath-vpc-cidr
  tags = {
    Name = local.vpc_name
  }
}

resource "aws_subnet" "ath" {
  vpc_id = aws_vpc.vpc-label.id
  cidr_block = var.ath-vpc-sub-cidr
}