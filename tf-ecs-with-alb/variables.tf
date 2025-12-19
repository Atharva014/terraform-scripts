variable "common_tags" {
  description = "Common tags to apply to all resources."
  type = map(string)
  default = {
    "user" = "tf_user"
    "managed_by" = "terraform"
    "env" = "dev"
  }
}

variable "region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "subnet_cidr" {
  type = list(string)
}