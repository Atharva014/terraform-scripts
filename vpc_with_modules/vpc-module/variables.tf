variable "aws_vpc_region" {
  type = string
  default = "ap-south-1"
}

variable "vpc_cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

variable "vpc_tag" {
  type = string
  default = "my-vpc"
}

variable "vpc_sub_count" {
  type = number
  default = 2
}

variable "vpc_web_pub_cidr_block" {
  type = list(string)
  default = [ "10.0.1.0/24", "10.0.2.0/24" ]
}

variable "vpc_app_priv_cidr_block" {
  type = list(string)
  default = [ "10.0.3.0/24", "10.0.4.0/24" ]
}

variable "vpc_db_priv_cidr_block" {
  type = list(string)
  default = [ "10.0.5.0/24", "10.0.6.0/24" ]
}