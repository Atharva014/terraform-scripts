# VPC creation
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = merge(var.common_tags, { Name = "ecs-vpc" })
}

# IGW creation
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = merge(var.common_tags, { Name = "ecs-igw" })
}

# Subnet creation
resource "aws_subnet" "this" {
  count = 2
  vpc_id = aws_vpc.this.id
  cidr_block = var.subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = merge(var.common_tags, { Name = "ecs-subnet-${count.index}" })
}

# Route table creation
resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = merge(var.common_tags, { Name = "ecs-rt" })
}

# Route table association
resource "aws_route_table_association" "this" {
  count = 2
  subnet_id = aws_subnet.this[count.index].id
  route_table_id = aws_route_table.this.id
}