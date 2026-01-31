module "vpc" {
  source = "./modules/networking"
  common_tags = var.common_tags
  region = var.region
  vpc_cidr = var.vpc_cidr
  pub_sub_cidr = var.pub_sub_cidr
}