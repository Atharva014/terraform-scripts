output "instance_ops" {
  value = module.ec2.instance_ips
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}