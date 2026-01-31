# VPC creation
resource "aws_vpc" "this" {
    cidr_block = var.vpc_cidr
    tags = merge( var.common_tags, { "Name" = "ASG-vpc" } )
}

# IGW creation
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = merge( var.common_tags, { "Name" = "ASG-igw" } )
}

# Subnet creation
resource "aws_subnet" "this" {
  count = length(var.pub_sub_cidr)
  vpc_id = aws_vpc.this.id
  cidr_block = var.pub_sub_cidr[count.index]
  tags = merge(var.common_tags, { Name = "ASG-pub-${count.index}" } )
}

# Public Route table creation
resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = merge( var.common_tags, { "Name" = "ASG-pub-rt" } )
}

# Public route table association
resource "aws_route_table_association" "this" {
  count = length(var.pub_sub_cidr)
  subnet_id = aws_subnet.this[count.index].id
  route_table_id = aws_route_table.this.id
}