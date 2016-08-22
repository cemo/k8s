variable "region" {}
variable "environment" {}
variable "s3_region" {}
variable "s3_bucket" {}
variable "name" {}
variable "aws_account_id" {}
variable "public_domain" {}
variable "private_domain" {}
variable "domain_hosted_zone_id" {}

variable "vpc_cidr_block" {
  default = {
    dev = "10.250.0.0/16"
  }
}

variable "availability_zones" {
  default = {
    eu-west-1 = ["a", "b", "c"]
    us-east-1 = ["a", "b", "c"]
  }
}

variable "vpn_ami_id" {
  default = {
    eu-west-1 = "ami-3c95f74f"
    us-east-1 = "ami-5d4ec54a"
  }
}

variable "vpn_instance_type" {
  default = "t2.micro"
}

variable "vpn_access_list" {
  default = [
    "80.229.27.83/32",
    "212.36.160.12/32"
  ]
}
