output "instnace_ips" {
  value = aws_instance.this[*].id
}