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
  count = 2
  domain = "vpc"
  tags = merge(var.common_tags, { Name = "wordpress-eip-${count.index}" } )
}

# Nat Gateway creation
resource "aws_nat_gateway" "this" {
  count = 2
  depends_on = [ aws_internet_gateway.this, aws_eip.this ]
  allocation_id = aws_eip.this[count.index].id
  subnet_id = aws_subnet.pub_sub[count.index].id
  tags = merge(var.common_tags, { Name = "wordpress-ngw-${count.index}" } )
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
  count = 2
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.this[count.index].id
  }
  tags = merge(var.common_tags, { Name = "wordpress-priv-rt-${count.index}" } )
}

# route table association
resource "aws_route_table_association" "pub_rt_association" {
  count = 2
  route_table_id = aws_route_table.pub_rt.id
  subnet_id = aws_subnet.pub_sub[count.index].id
}

resource "aws_route_table_association" "priv_rt_association" {
  count = 2
  route_table_id = aws_route_table.priv_rt[count.index].id
  subnet_id = aws_subnet.priv_sub[count.index].id
}

# Web server Security group
resource "aws_security_group" "web_srv_sg" {
  name = "web-sg"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}