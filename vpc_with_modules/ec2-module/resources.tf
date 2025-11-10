# SG creation
resource "aws_security_group" "allow_ssh_sg" {
  name = "Allow ssh"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id = var.vpc_id
  tags = {
    Name = "Allow SSH"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_inbound" {
  security_group_id = aws_security_group.allow_ssh_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  to_port = 22
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.allow_ssh_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}


# Instance creation
resource "aws_instance" "web_instance_label" {
  count = var.web_instance_count
  subnet_id = var.web_instance_subnet[count.index].id
  vpc_security_group_ids = [ aws_security_group.allow_ssh_sg.id ]
  ami = var.web_instance_ami
  instance_type = var.web_instance_type
  key_name = var.common_key_pair
  tags = {
    Name = "${var.vpc_tag}-web-${count.index}"
  }
  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }
}

resource "aws_instance" "app_instance_label" {
  subnet_id = var.app_instance_subnet[count.index].id  
  count = var.app_instance_count
  vpc_security_group_ids = [ aws_security_group.allow_ssh_sg.id ]
  ami = var.app_instance_ami
  instance_type = var.app_instance_type
  key_name = var.common_key_pair
  tags = {
    Name = "${var.vpc_tag}-app-${count.index}"
  }
  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }
}

resource "aws_instance" "db_instance_label" {
  count = var.db_instance_count
  subnet_id = var.db_instance_subnet[count.index].id
  vpc_security_group_ids = [ aws_security_group.allow_ssh_sg.id ]
  ami = var.db_instance_ami
  instance_type = var.db_instance_type
  key_name = var.common_key_pair
  tags = {
    Name = "${var.vpc_tag}-db-${count.index}"
  }
  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }
}