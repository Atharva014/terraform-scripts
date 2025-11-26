# SG creation
resource "aws_security_group" "allow_ssh_sg" {
  name = "Allow ssh"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id = var.vpc_id
  tags = {
    Name = "ath-ssh-sg"
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

# Instance Creation
resource "aws_instance" "this" {
  instance_type = var.instance_type
  ami = var.instance_ami
  key_name = var.instance_key
  subnet_id = var.subnet
  associate_public_ip_address = true
  vpc_security_group_ids = [ aws_security_group.allow_ssh_sg.id ]
  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }
  tags = {
    Name = "ath-instance"
  }
  user_data = <<-EOF
    #!/bin/bash
    yum install -y amazon-efs-utils
    mkdir -p /mnt/efs
    mount -t efs ${var.efs_id}:/ /mnt/efs
  EOF
}