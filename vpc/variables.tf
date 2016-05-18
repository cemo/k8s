variable "region" {}
variable "environment" {}
variable "s3_region" {}
variable "s3_bucket" {}

variable "vpc_cidr_block" {
  default = {
    dev  = "1.0.0.0/16"
    test = "2.0.0.0/16"
    stge = "3.0.0.0/16"
    prod = "4.0.0.0/16"
    hub  = "5.0.0.0/16"
  }
}

variable "availability_zones" {
  default = {
    dev  = "a"
    test = "b"
    stge = "a,b,d"
    prod = "a,b,d"
    hub  = "d"
  }
}

variable "public_domain" {
  default = "devscape.io"
}

variable "private_domain" {
  default = "devscape.private"
}

variable "domain_hosted_zone_id" {
  default = "Z6SB6MX6NJNME"
}
