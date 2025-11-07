output "vpc_id" {
  value = aws_vpc.vpc-label.id
}

output "vpc_cidr" {
  value = aws_vpc.vpc-label.cidr_block
}