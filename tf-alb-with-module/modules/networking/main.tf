# VPC creation
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block
  tags = merge(var.common_tags, { Name = "ath-vpc" })
}

# Internet creation
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = merge(var.common_tags, { Name = "ath-igw" })
}

# Subnet creation
resource "aws_subnet" "public_sub" {
  vpc_id = aws_vpc.this.id
  count = var.subnet_count
  cidr_block = var.subnet_cidr_block[count.index]
  map_public_ip_on_launch = true
  enable_resource_name_dns_a_record_on_launch = true
  tags = merge(var.common_tags, { Name = "ath-sub-${count.index}" })
  availability_zone = var.vpc_az[count.index]
}

# Route Table creation
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = merge(var.common_tags, { Name = "ath-public-rt" })
}

# route table association
resource "aws_route_table_association" "vpc_rt_association_label" {
  count = var.subnet_count
  subnet_id = aws_subnet.public_sub[count.index].id
  route_table_id = aws_route_table.public_rt.id
}