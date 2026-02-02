module "vpc" {
  source = "./modules/networking"
  common_tags = var.common_tags
  region = var.region
  vpc_cidr = var.vpc_cidr
  pub_sub_cidr = var.pub_sub_cidr
}

module "asg" {
  source = "./modules/auto-scaling-group"
  common_tags = var.common_tags
  sg_ids = [ module.vpc.http_sg_id, module.vpc.ssh_sg_id ]
  vpc_id = module.vpc.vpc_id
}