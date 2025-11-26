output "AZs" {
  value = data.aws_availability_zones.available.names
}

output "vpc_id" {
  value = data.aws_vpc.default.id
}

output "subnet_ids" {
  value = data.aws_subnets.default.ids
}

output "instance_ip" {
  value = module.ec2.instance_ip
}

output "efs_id" {
  value = module.efs.efs_id
}