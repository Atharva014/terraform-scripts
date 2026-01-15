output "vpc_id" {
  value = aws_vpc.this.id
}

output "pub_sub_ids" {
  value = aws_subnet.pub_sub[*].id
}

output "priv_sub_ids" {
  value = aws_subnet.priv_sub[*].id
}

output "web_srv_sg_id" {
  value = aws_security_group.web_srv_sg.id
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}