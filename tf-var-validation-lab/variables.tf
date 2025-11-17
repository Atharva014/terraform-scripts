variable "region" {
  type = string
  validation {
    condition = contains(["ap-south-1", "us-east-1"], var.region)
    error_message = "Region should be either ap-south-1 or us-east-1"
  }
}

variable "cidr_block" {
  type = string
  validation {
    condition     = can(cidrhost(var.cidr_block, 0))
    error_message = "Must be a valid IPv4 CIDR block (e.g., 10.0.0.0/16)"
  }
}