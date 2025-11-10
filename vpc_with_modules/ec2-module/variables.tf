variable "aws_region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_tag" {
  type = string
  default = "my-vpc"
}

variable "web_instance_subnet" {
  type = list(string)
}

variable "app_instance_subnet" {
  type = list(string)
}

variable "db_instance_subnet" {
  type = list(string)
}

variable "web_instance_count" {
  type = number
}

variable "app_instance_count" {
  type = number
}

variable "db_instance_count" {
  type = number
}

variable "web_instance_ami" {
  type = string
}

variable "app_instance_ami" {
  type = string
}

variable "db_instance_ami" {
  type = string
}

variable "web_instance_type" {
  type = string
}

variable "app_instance_type" {
  type = string
}

variable "db_instance_type" {
  type = string
}

variable "common_key_pair" {
  type = string
}