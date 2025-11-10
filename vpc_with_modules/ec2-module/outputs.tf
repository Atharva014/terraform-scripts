output "web_instance_public_ips" {
  value = aws_instance.web_instance_label[*].public_ip
}