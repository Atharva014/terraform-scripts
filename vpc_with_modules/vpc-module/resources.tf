# VPC Creation
resource "aws_vpc" "aws_vpc_label" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.vpc_tag
  }
}

# Internet Gateway Creation
resource "aws_internet_gateway" "vpc_igw_label" {
  vpc_id = aws_vpc.aws_vpc_label.id
  tags = {
    Name = "${var.vpc_tag}-igw"
  }
}

# Public Subnet Creation
resource "aws_subnet" "vpc_web_pub_sub_label" {
  vpc_id = aws_vpc.aws_vpc_label.id
  count = var.vpc_sub_count

  cidr_block = var.vpc_web_pub_cidr_block[count.index]
  map_public_ip_on_launch = true
  enable_resource_name_dns_a_record_on_launch = true
  tags = {
    Name = "${var.vpc_tag}-web-pub-${count.index}"
  }
}

# Private Subnet Creation
resource "aws_subnet" "vpc_app_priv_sub_label" {
  vpc_id = aws_vpc.aws_vpc_label.id
  count = var.vpc_sub_count

  cidr_block = var.vpc_app_priv_cidr_block[count.index]
  enable_resource_name_dns_a_record_on_launch = true
  tags = {
    Name = "${var.vpc_tag}-app-priv-${count.index}"
  }
}

resource "aws_subnet" "vpc_db_priv_sub_label" {
  vpc_id = aws_vpc.aws_vpc_label.id
  count = var.vpc_sub_count

  cidr_block = var.vpc_db_priv_cidr_block[count.index]
  enable_resource_name_dns_a_record_on_launch = true
  tags = {
    Name = "${var.vpc_tag}-db-priv-${count.index}"
  }
}

# Elastic Ip Creation
resource "aws_eip" "vpc_eip_label" {
  count = var.vpc_sub_count
  domain = "vpc"
}

# Nat Gateway Creation
resource "aws_nat_gateway" "vpc_ngw_label" {
  count = var.vpc_sub_count
  depends_on = [ aws_internet_gateway.vpc_igw_label , aws_eip.vpc_eip_label ]
  allocation_id = aws_eip.vpc_eip_label[count.index].id
  subnet_id = aws_subnet.vpc_web_pub_sub_label[count.index].id
  tags = {
    Name = "${var.vpc_tag}-ngw-${count.index}"
  }
}

# Public Route table creation
resource "aws_route_table" "vpc_web_sub_rt_label" {
  vpc_id = aws_vpc.aws_vpc_label.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw_label.id
  }
  tags = {
    Name = "${var.vpc_tag}-web-sub-rt"
  }
}

# Private Route table creation
resource "aws_route_table" "vpc_app_sub_rt_label" {
  count = var.vpc_sub_count
  vpc_id = aws_vpc.aws_vpc_label.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.vpc_ngw_label[count.index].id
  }
  tags = {
    Name = "${var.vpc_tag}-app-sub-rt"
  }
}

resource "aws_route_table" "vpc_db_sub_rt_label" {
  count = var.vpc_sub_count
  vpc_id = aws_vpc.aws_vpc_label.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.vpc_ngw_label[count.index].id
  }
  tags = {
    Name = "${var.vpc_tag}-db-sub-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "vpc_web_rt_association" {
  count = var.vpc_sub_count
  subnet_id = aws_subnet.vpc_web_pub_sub_label[count.index].id
  route_table_id = aws_route_table.vpc_web_sub_rt_label.id
}

resource "aws_route_table_association" "vpc_app_rt_association" {
  count = var.vpc_sub_count
  subnet_id = aws_subnet.vpc_app_priv_sub_label[count.index].id
  route_table_id = aws_route_table.vpc_app_sub_rt_label[count.index].id
}

resource "aws_route_table_association" "vpc_db_rt_association" {
  count = var.vpc_sub_count
  subnet_id = aws_subnet.vpc_db_priv_sub_label[count.index].id
  route_table_id = aws_route_table.vpc_db_sub_rt_label[count.index].id
}