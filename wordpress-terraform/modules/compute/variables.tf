variable "common_tags" {
  type = map(string)
}

variable "pub_sub_ids" {
  type = list(string)
}

variable "instance_ami" {
  type = string
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "instance_key" {
  type = string
}

variable "instance_count" {
  type = number
  default = 2
}

variable "web_srv_sg_id" {
  type = string
}

variable "db_endpoint" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}