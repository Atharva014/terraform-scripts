variable "common_tags" {
  type = map(string)
}

variable "region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "pub_sub_cidr" {
  type = list(string)
}