variable "common_tags" {
  type = map(string)
}

variable "vpc_id" {
  type = string
}

variable "sg_ids" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
}

variable "target_group_arns" {
  type    = list(string)
}