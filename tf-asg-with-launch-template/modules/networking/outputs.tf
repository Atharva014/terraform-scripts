output "vpc_id" {
  value = aws_vpc.this.id
}

output "pub_sub_ids" {
  value = aws_subnet.this[*].id
}

output "ssh_sg_id" {
  value = aws_security_group.allow-ssh.id
}

output "http_sg_id" {
  value = aws_security_group.allow-http.id
}