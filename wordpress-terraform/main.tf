module "vpc" {
  source = "./modules/networking"
  common_tags = var.common_tags
  cidr_block = var.vpc_cidr
  pub_sub_cidr = var.pub_subnet_cidr
  priv_sub_cidr = var.priv_subnet_cidr
}