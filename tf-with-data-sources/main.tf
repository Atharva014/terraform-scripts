# VPC Creation
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  
  tags = {
    Name = "remote-state-test-vpc"
    Environment = "dev"
  }
}

#Subnet Creation
resource "aws_subnet" "this" {
  count = 2
  vpc_id = aws_vpc.this.id
  cidr_block = var.sub_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "remote-state-test-subnet-${count.index}"
  }
}

#Instance Creation
resource "aws_instance" "this" {
  ami = data.aws_ami.amz_linux.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.this[0].id
  tags = {
    Name = "test-instance"
  }
}