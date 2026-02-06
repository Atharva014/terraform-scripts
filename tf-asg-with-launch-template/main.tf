module "vpc" {
  source = "./modules/networking"
  common_tags = var.common_tags
  region = var.region
  vpc_cidr = var.vpc_cidr
  pub_sub_cidr = var.pub_sub_cidr
}

module "alb" {
  source = "./modules/load-balancer"
  common_tags = var.common_tags
  vpc_id = module.vpc.vpc_id
  http_sg_id = module.vpc.http_sg_id
  subnet_ids = module.vpc.pub_sub_ids
}

module "asg" {
  source = "./modules/auto-scaling-group"
  common_tags = var.common_tags
  sg_ids = [ module.vpc.http_sg_id, module.vpc.ssh_sg_id ]
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.pub_sub_ids
  target_group_arns = [ module.alb.target_group_arn ]
}
