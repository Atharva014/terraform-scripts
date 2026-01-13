# Instance creation
resource "aws_instance" "this" {
  count = var.instance_count
  subnet_id = var.pub_sub_ids[count.index]
  instance_type = var.instance_type
  ami = var.instance_ami
  key_name = var.instance_key
  vpc_security_group_ids = [ var.web_srv_sg_id ]
  associate_public_ip_address = true
  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }
  tags = merge(var.common_tags, { Name = "wordpress-srv-${count.index}" })
}