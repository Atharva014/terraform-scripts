resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  
  tags = {
    Name = "remote-state-test-vpc"
    Environment = "dev"
  }
}

resource "aws_subnet" "this" {
  count = 2
  vpc_id = aws_vpc.this.id
  cidr_block = var.sub_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "remote-state-test-subnet-${count.index}"
  }
}