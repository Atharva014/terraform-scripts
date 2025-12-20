output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_cidr" {
  value = aws_vpc.this.cidr_block
}

output "subnet_cidr" {
  value = aws_subnet.this[*].cidr_block
}

output "subnet_azs" {
  value = aws_subnet.this[*].availability_zone
}

output "subnet_ids" {
  value = aws_subnet.this[*].id
}