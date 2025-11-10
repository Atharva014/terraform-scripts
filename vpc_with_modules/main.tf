module "vpc_mod_label" {
  source = "./vpc-module"
  aws_vpc_region = var.region
  vpc_cidr_block = "192.168.0.0/16"
  vpc_tag = "sbi-vpc"
  vpc_sub_count = 2
  vpc_web_pub_cidr_block = [ "192.168.1.0/24", "192.168.2.0/24" ]
  vpc_app_priv_cidr_block = [ "192.168.3.0/24", "192.168.4.0/24" ]
  vpc_db_priv_cidr_block = [ "192.168.5.0/24", "192.168.6.0/24" ]
}

module "ec2_mod_label" {
  source = "./ec2-module"
  aws_region = var.region
  vpc_id = module.vpc_mod_label.vpc_id
  vpc_tag = module.vpc_mod_label.vpc_tag
  
  web_instance_subnet = module.vpc_mod_label.vpc_web_sub_ids
  web_instance_count = 2
  web_instance_ami = "ami-0614680123427b75e"
  web_instance_type = "t3.micro"

  app_instance_subnet = module.vpc_mod_label.vpc_app_sub_ids
  app_instance_count = 2
  app_instance_ami = "ami-0614680123427b75e"
  app_instance_type = "t3.micro"

  db_instance_subnet = module.vpc_mod_label.vpc_db_sub_ids
  db_instance_count = 2
  db_instance_ami = "ami-0614680123427b75e"
  db_instance_type = "t3.micro"
  
  common_key_pair = "linux-key"
}