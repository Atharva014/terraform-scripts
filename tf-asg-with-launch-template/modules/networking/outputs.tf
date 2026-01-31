output "pub_sub_ids" {
  value = aws_subnet.this[*].id
}