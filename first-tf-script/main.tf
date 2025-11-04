terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "6.19.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "ath-vpc-label" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "ath-vpc"
  }
}

resource "aws_internet_gateway" "ath-igw-label" {
  vpc_id = aws_vpc.ath-vpc-label.id
  tags = {
    Name = "ath-igw"
  }
}

resource "aws_subnet" "ath-pub-sub-label" {
  vpc_id = aws_vpc.ath-vpc-label.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = "true"
  enable_resource_name_dns_a_record_on_launch = "true"
  tags = {
    Name = "ath-pub-sub"
  }
}

resource "aws_subnet" "ath-priv-sub-label" {
  vpc_id = aws_vpc.ath-vpc-label.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1b"
  enable_resource_name_dns_a_record_on_launch = "true"
  tags = {
    Name = "ath-priv-sub"
  }
}

resource "aws_route_table" "ath-pub-rt-label" {
  vpc_id = aws_vpc.ath-vpc-label.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ath-igw-label.id
  }
  tags = {
    Name = "ath-pub-rt"
  }
}

resource "aws_route_table_association" "ath-pub-rt-association-label" {
  subnet_id = aws_subnet.ath-pub-sub-label.id
  route_table_id = aws_route_table.ath-pub-rt-label.id
}

resource "aws_security_group" "ath-sg-label" {
  name = "ath-sg"
  description = "Allow SSH traffic for instances."
  vpc_id = aws_vpc.ath-vpc-label.id
}

resource "aws_vpc_security_group_ingress_rule" "allow-ssh-traffic" {
  security_group_id = aws_security_group.ath-sg-label.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "tcp"
  to_port = "22"
  from_port = "22"
}

resource "aws_vpc_security_group_egress_rule" "allow-all-traffic" {
  security_group_id = aws_security_group.ath-sg-label.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}