# SG creation
resource "aws_security_group" "allow_efs_sg" {
  name        = "efs-sg"
  description = "Allow NFS traffic from instance"
  vpc_id      = var.vpc_id
  tags = {
    Name = "ath-efs-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_inbound" {
  security_group_id = aws_security_group.allow_efs_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 2049
  to_port = 2049
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.allow_efs_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}

# EFS Creation
resource "aws_efs_file_system" "this" {
  region = var.region
  tags = {
    Name = "ath-efs"
  }
}

resource "aws_efs_mount_target" "this" {
  count = length(var.subnet_ids)
  file_system_id = aws_efs_file_system.this.id
  security_groups = [ aws_security_group.allow_efs_sg.id ]
  subnet_id = var.subnet_ids[count.index]
}