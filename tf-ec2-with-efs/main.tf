module "efs" {
  source = "./modules/efs"
  region = var.region
  vpc_id = data.aws_vpc.default.id
  subnet_ids = data.aws_subnets.default.ids
}

module "ec2" {
  depends_on = [ module.efs ]
  source = "./modules/compute"
  instance_ami = "ami-03695d52f0d883f65"
  instance_key = "linux-key"
  instance_type = "t3.micro"
  subnet = data.aws_subnets.default.ids[0]
  vpc_id = data.aws_vpc.default.id
  efs_id = module.efs.efs_id
}