variable "environment" {}

variable "region" {
  default = {
    dev  = "us-east-1"
    test = "us-east-1"
    stge = "us-east-1"
    prod = "us-east-1"
  }
}

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

variable "ubuntu_ami_id" {
  default = {
    dev  = "ami-fce3c696"
    test = "ami-fce3c696"
    stge = "ami-fce3c696"
    prod = "ami-fce3c696"
  }
}

variable "domain" {
  default = "devscape.io"
}

variable "domain_hosted_zone_id" {
  default = "Z6SB6MX6NJNME"
}

variable "bastion_ssh_cidr_blocks" {
  default = "82.132.229.194/32"
}
