output "vpc_id" {
  value = aws_vpc.vpc_label.id
}

output "subnet_ids" {
  value = aws_subnet.vpc_sub_label[*].id
}
