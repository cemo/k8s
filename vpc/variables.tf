variable "region" {}
variable "environment" {}
variable "s3_region" {}
variable "s3_bucket" {}

variable "vpc_cidr_block" {
  default = {
    dev  = "10.100.0.0/16"
    test = "10.200.0.0/16"
    stge = "10.300.0.0/16"
    prod = "5.0.0.0/16"
  }
}

variable "availability_zones" {
  default = {
    dev  = "a,b,d"
    test = "a,b,d"
    stge = "a,b,d"
    prod = "a,b,d"
  }
}

variable "domain" {
  default = "devscape.io"
}

variable "domain_hosted_zone_id" {
  default = "Z6SB6MX6NJNME"
}

variable "bastion_ami_id" {
  default = "ami-4b628b26"
}

variable "bastion_ssh_access_list" {
  default = "82.132.245.10/32"
}
