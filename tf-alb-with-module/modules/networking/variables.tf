variable "common_tags" {
  type = map(string)
}

variable "subnet_count" {
  type = number
  default = 2
}

variable "vpc_cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  type = list(string)
  default = [ "10.0.1.0/24", "10.0.2.0/24" ]
}

variable "vpc_az" {
  type = list(string)
  default = [ "ap-south-1a", "ap-south-1b" ]
}