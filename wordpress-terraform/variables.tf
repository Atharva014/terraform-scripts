variable "common_tags" {
  type = map(string)
  default = {
    "users" = "tf_user"
    "env" = "dev"
    "terraform" = "true"
    "proj" = "wordpress"
  }
}

variable "region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "pub_subnet_cidr" {
  type = list(string)
}

variable "priv_subnet_cidr" {
  type = list(string)
}

variable "db_password" {
  type = string
  sensitive = true
}