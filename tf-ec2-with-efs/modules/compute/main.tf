# Insatnce SG Creation
resource "aws_security_group" "instance_sg" {
  name = "insatnce-sg"
  description = "Allow all traffic from ALB security group."
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "instance_sg_ingress" {
  security_group_id = aws_security_group.instance_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "instance_sg_egress" {
  security_group_id = aws_security_group.instance_sg.id
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
  vpc_security_group_ids = [ aws_security_group.instance_sg.id ]
  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }
}