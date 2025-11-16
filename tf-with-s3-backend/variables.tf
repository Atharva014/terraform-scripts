variable "region" {
  type = string
}

variable "vpc_cidr" {
  type    = string
  default = "10.50.0.0/16"
}

variable "subnet_cidr" {
  type    = string
  default = "10.50.1.0/24"
}