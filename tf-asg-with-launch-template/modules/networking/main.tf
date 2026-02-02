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

# SG creation
resource "aws_security_group" "allow-ssh" {
  name = "ssh-sg"
  description = "Allow ssh traffic."
  vpc_id = aws_vpc.this.id
  tags = merge(var.common_tags, { Name = "ASG-ssh-sg" })

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow-http" {
  name = "http-sg"
  description = "Allow http traffic."
  vpc_id = aws_vpc.this.id
  tags = merge(var.common_tags, { Name = "ASG-http-sg" })

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}
