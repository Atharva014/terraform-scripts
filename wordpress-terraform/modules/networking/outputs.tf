output "vpc_id" {
  value = aws_vpc.this.id
}

output "pub_sub_ids" {
  value = aws_subnet.pub_sub[*].id
}

output "priv_sub_ids" {
  value = aws_subnet.priv_sub[*].id
}