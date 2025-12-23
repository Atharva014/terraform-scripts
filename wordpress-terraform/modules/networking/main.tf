# VPC creation
resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  tags = merge(var.common_tags, { Name = "wordpress-vpc" } )
}

# IGW creation
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = merge(var.common_tags, { Name = "wordpress-igw" } )
}

# Public subnet creation
resource "aws_subnet" "pub_sub" {
  count = 2
  vpc_id = aws_vpc.this.id
  cidr_block = var.pub_sub_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = merge(var.common_tags, { Name = "wordpress-pub-${count.index}" } )
}

# Private subnet creation
resource "aws_subnet" "priv_sub" {
  count = 2
  vpc_id = aws_vpc.this.id
  cidr_block = var.priv_sub_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = merge(var.common_tags, { Name = "wordpress-priv-${count.index}" } )
}

# Elastic Ip creation
resource "aws_eip" "this" {
  domain = "vpc"
}

# Nat Gateway creation
resource "aws_nat_gateway" "this" {
  depends_on = [ aws_internet_gateway.this, aws_eip.this ]
  allocation_id = aws_eip.this.id
  subnet_id = aws_subnet.pub_sub[0].id
  tags = merge(var.common_tags, { Name = "wordpress-ngw" } )
}

# Route table creation
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = merge(var.common_tags, { Name = "wordpress-pub-rt" } )
}

resource "aws_route_table" "priv_rt" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.this.id
  }
  tags = merge(var.common_tags, { Name = "wordpress-priv-rt" } )
}

# route table association
resource "aws_route_table_association" "pub_rt_association" {
  count = 2
  route_table_id = aws_route_table.pub_rt.id
  subnet_id = aws_subnet.pub_sub[count.index].id
}

resource "aws_route_table_association" "priv_rt_association" {
  count = 2
  route_table_id = aws_route_table.priv_rt.id
  subnet_id = aws_subnet.priv_sub[count.index].id
}
