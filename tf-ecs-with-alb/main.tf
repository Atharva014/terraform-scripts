module "vpc" {
  source = "./modules/networking"
  vpc_cidr = var.vpc_cidr
  subnet_cidr = var.subnet_cidr
  common_tags = var.common_tags
}

module "ecs" {
  source = "./modules/ecs"
  region = var.region
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.subnet_ids
  alb_sg_id = module.ALB.alb_sg_id
  common_tags = var.common_tags
  target_group_arn = module.ALB.tg_arn
}

module "ALB" {
  source = "./modules/load_balancer"
  subnet_ids = module.vpc.subnet_ids
  vpc_id = module.vpc.vpc_id
  common_tags = var.common_tags
}