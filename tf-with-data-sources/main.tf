resource "aws_vpc" "test" {
  cidr_block = var.vpc_cidr
  
  tags = {
    Name = "remote-state-test-vpc"
    Environment = "dev"
  }
}

resource "aws_subnet" "test" {
  vpc_id     = aws_vpc.test.id
  cidr_block = var.sub_cidr
  
  tags = {
    Name = "remote-state-test-subnet"
  }
}