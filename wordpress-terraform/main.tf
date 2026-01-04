module "vpc" {
  source = "./modules/networking"
  common_tags = var.common_tags
  cidr_block = var.vpc_cidr
  pub_sub_cidr = var.pub_subnet_cidr
  priv_sub_cidr = var.priv_subnet_cidr
}

module "rds" {
  source = "./modules/rds"
  common_tags = var.common_tags
  vpc_id = module.vpc.vpc_id
  priv_sub_ids = module.vpc.priv_sub_ids
  db_name = "atharva-db"
  db_username = "root"
  db_password = var.db_password
  web_sg_id = ""
}