output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr
}

output "subnet_cidr" {
  value = module.vpc.subnet_cidr
}

output "subnet_azs" {
  value = module.vpc.subnet_azs
}

