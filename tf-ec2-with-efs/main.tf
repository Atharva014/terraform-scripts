module "ec2" {
  source = "./modules/compute"
  instance_ami = "ami-03695d52f0d883f65"
  instance_key = "linux-key"
  instance_type = "t2.micro"
  subnet = data.aws_subnets.default.ids[0]
  vpc_id = data.aws_vpc.default.id
}