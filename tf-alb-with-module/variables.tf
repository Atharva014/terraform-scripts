variable "common_tags" {
  description = "Common tags to apply to all resources."
  type = map(string)
  default = {
    "env" = "dev"
    "managedBy" = "terraform"
    "user" = "tf_user"
  }
}

variable "aws_region" {
  type = string
  default = "ap-south-1"
}