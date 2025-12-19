variable "vpc_cidr" {
  type = string
}

variable "subnet_cidr" {
  type = list(string)
}

variable "common_tags" {
  type = map(string)
}