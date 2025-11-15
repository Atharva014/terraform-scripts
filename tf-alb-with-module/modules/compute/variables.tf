variable "common_tags" {
  type = map(string)
}

variable "vpc_id" {
  type = string
}

variable "instance_ami" {
  type = string
  default = "ami-03695d52f0d883f65"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "instance_key" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "instance_count" {
  type = number
  default = 2
}