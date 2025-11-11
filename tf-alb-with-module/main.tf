module "vpc_module" {
  source = "./modules/networking"
  common_tags = var.common_tags
  subnet_count = 2
  vpc_cidr_block = "192.168.0.0/16"
  subnet_cidr_block = [ "192.168.1.0/24", "192.168.2.0/24" ]
  vpc_az = [ "ap-south-1a", "ap-south-1b" ]
}