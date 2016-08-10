variable "region" {
  default = "eu-west-1"
}
variable "environment" {}
variable "s3_region" {}
variable "s3_bucket" {}

variable "aws_account_id" {
  default = "323333154476"
}

variable "public_domain" {
  default = "anto.cloud"
}

variable "private_domain" {
  default = "anto.private"
}

variable "domain_hosted_zone_id" {
  default = "ZD3WE5CFYUNY7"
}

variable "vpc_cidr_block" {
  default = {
    shared = "10.0.0.0/16"
    dev    = "10.100.0.0/16"
    test   = "10.150.0.0/16"
    prod   = "10.200.0.0/16"
  }
}

variable "availability_zones" {
  default = {
    eu-west-1 = ["a", "b", "c"]
  }
}

variable "vpn_ami_id" {
  default = {
    eu-west-1 = "ami-3c95f74f"
  }
}

variable "vpn_instance_type" {
  default = "t2.micro"
}

variable "vpn_access_list" {
  default = [
    "80.229.27.83/32"
  ]
}
