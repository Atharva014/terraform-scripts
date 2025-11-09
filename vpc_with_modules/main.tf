module "vpc_mod_label" {
  source = "./vpc-module"
  aws_vpc_region = var.region
  vpc_cider_block = "192.168.0.0/16"
  vpc_tag = "sbi-vpc"
  vpc_sub_count = 2
  vpc_web_pub_cidr_block = [ "192.168.1.0/24", "192.168.2.0/24" ]
  vpc_app_priv_cidr_block = [ "192.168.3.0/24", "192.168.4.0/24" ]
  vpc_db_priv_cidr_block = [ "192.168.5.0/24", "192.168.6.0/24" ]
}