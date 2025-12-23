variable "common_tags" {
  type = map(string)
}

variable "cidr_block" {
  type = string
}

variable "pub_sub_cidr" {
  type = list(string)
}

variable "priv_sub_cidr" {
  type = list(string)
}