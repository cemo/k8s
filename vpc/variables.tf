variable "region" {
  default = "us-east-1"
}
variable "environment" {}
variable "s3_region" {}
variable "s3_bucket" {}

variable "aws_account_id" {
  default = "323333154476"
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

variable "vpc_cidr_block" {
  default = {
    shared = "10.0.0.0/16"
    dev    = "10.100.0.0/16"
    test   = "10.150.0.0/16"
    prod   = "10.200.0.0/16"
  }
}

variable "public_subnet_count" {}

variable "private_subnet_count" {}

variable "vpn_on_off" {}
