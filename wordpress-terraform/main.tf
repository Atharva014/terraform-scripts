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
  db_name = var.db_name
  db_username = var.db_username
  db_password = var.db_password
  web_sg_id = module.vpc.web_srv_sg_id
}

module "ec2" {
  source = "./modules/compute"
  common_tags = var.common_tags
  instance_count = 2
  pub_sub_ids = module.vpc.pub_sub_ids
  instance_ami = "ami-0ced6a024bb18ff2e"
  instance_type = "t3.micro"
  instance_key = "linux-key"
  web_srv_sg_id = module.vpc.web_srv_sg_id
  db_endpoint = module.rds.db_endpoint
  db_name = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}

module "alb" {
  source = "./modules/load-balancer"
  alb_sg_id = module.vpc.alb_sg_id
  common_tags = var.common_tags
  instance_count = 2
  subnet_ids = module.vpc.pub_sub_ids
  instance_ids = module.ec2.instances_ids
  vpc_id = module.vpc.vpc_id
}