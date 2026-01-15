variable "common_tags" {
  type = map(string)
}

variable "vpc_id" {
  type = string
}

variable "instance_ids" {
    type = list(string)
}

variable "alb_sg_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "instance_count" {
  type = number
}