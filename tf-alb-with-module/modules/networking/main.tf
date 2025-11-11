# VPC creation
resource "aws_vpc" "vpc_label" {
  cidr_block = var.vpc_cidr_block
  tags = merge(var.common_tags, {Name = "ath-vpc"})
}

# Internet creation
resource "aws_internet_gateway" "vpc_igw_label" {
  vpc_id = aws_vpc.vpc_label.id
  tags = merge(var.common_tags, {Name = "ath-igw"})
}

# Subnet creation
resource "aws_subnet" "vpc_sub_label" {
  vpc_id = aws_vpc.vpc_label.id
  count = var.subnet_count
  cidr_block = var.subnet_cidr_block[count.index]
  map_public_ip_on_launch = true
  enable_resource_name_dns_a_record_on_launch = true
  tags = merge(var.common_tags, {Name = "ath-sub-${count.index}"})
  availability_zone = var.vpc_az[count.index]
}

# Route Table creation
resource "aws_route_table" "vpc_rt_label" {
  vpc_id = aws_vpc.vpc_label.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw_label.id
  }
  tags = merge(var.common_tags, {Name = "ath-public-rt"})
}

# route table association
resource "aws_route_table_association" "vpc_rt_association_label" {
  count = var.subnet_count
  subnet_id = aws_subnet.vpc_sub_label[count.index].id
  route_table_id = aws_route_table.vpc_rt_label.id
}