variable "common_tags" {
  type = map(string)
  default = {
    "user" = "tf_user"
    "terraform" = "true"
    "env" = "dev"
    "project" = "ASG"
  }
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