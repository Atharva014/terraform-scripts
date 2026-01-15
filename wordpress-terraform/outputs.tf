output "instance_ops" {
  value = module.ec2.instance_ips
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}