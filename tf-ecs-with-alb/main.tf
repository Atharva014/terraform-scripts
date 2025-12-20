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
}