variable "common_tags" {
  type = map(string)
  default = {
    "user" = "tf-user"
    "terraform" = "true"
    "env" = "dev"
    "project" = "static-website"
  }
}

variable "region" {
  type = string
}

variable "bucket_name" {
  type = string
}