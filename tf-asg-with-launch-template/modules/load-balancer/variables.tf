variable "common_tags" {
    type = map(string)
}

variable "vpc_id" {
  type = string
}

variable "http_sg_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}