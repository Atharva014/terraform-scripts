output "aws_availability_zones" {
  value = data.aws_availability_zones.available.names
}

output "vpc_cidr" {
  value = aws_vpc.this.cidr_block
}

output "subnet_cidr_block" {
  value = aws_subnet.this[*].cidr_block
}

output "subnet_id" {
  value = aws_subnet.this[*].id
}

output "instance_ami" {
  value = data.aws_ami.amz_linux.name
}

output "instance_id" {
  value = data.aws_ami.amz_linux.id
}