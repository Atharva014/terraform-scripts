variable "ath-vpc-cidr" {
  type = string
  default = "10.20.0.0/16"
}

variable "ath-vpc-name" {
  type = string
  default = "ath-vpc"
}

variable "ath-vpc-sub-cidr" {
  type = string
}

variable "env-types" {
  type = list(string)
  default = [ "PROD", "DB", "UAT" ]
}

variable "srv-types" {
  type = list(string)
  default = [ "WEB", "DB", "DNS", "DHCP" ]
}