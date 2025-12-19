module "vpc" {
  source = "./modules/networking"
  vpc_cidr = var.vpc_cidr
  subnet_cidr = var.subnet_cidr
  common_tags = var.common_tags
}