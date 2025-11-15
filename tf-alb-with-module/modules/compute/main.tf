# ALB SG creation
resource "aws_security_group" "alb_sg" {
  name = "ALB-sg"
  description = "Allow web server traffic for insatnce."
  vpc_id = var.vpc_id
  tags = merge(var.common_tags, { Name = "ath-alb-sg" })
}

resource "aws_vpc_security_group_ingress_rule" "alb_sg_ingress" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "alb_sg_egress" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}

# Insatnce SG Creation
resource "aws_security_group" "instance_sg" {
  name = "insatnce-sg"
  description = "Allow all traffic from ALB security group."
  vpc_id = var.vpc_id
  tags = merge(var.common_tags, { Name = "ath-instance-sg" })
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

# Instance creation
resource "aws_instance" "this" {
  count = var.instance_count
  subnet_id = var.subnet_ids[ count.index % length(var.subnet_ids) ]
  
  instance_type = var.instance_type
  ami = var.instance_ami
  key_name = var.instance_key
  vpc_security_group_ids = [ aws_security_group.instance_sg.id ]
  associate_public_ip_address = true
  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }
  tags = merge(var.common_tags, { Name = "ath-web-srv" })
}