variable "name" {}

variable "environment" {}

variable "region" {}

variable "vpc_id" {}

variable "subnet_id" {}

variable "hosted_zone_id" {}

variable "openvpn_ami_id" {
  default = {
    eu-west-1 = "ami-3c95f74f"
  }
}

variable "instance_type" {
  default = {
    dev = "t2.micro"
  }
}

variable "key_name" {
  default = {
    dev = "k8s-dev"
  }
}

variable "access_list" {
  default = [
    "80.229.27.83/32",
    "212.36.160.12/32",
  ]
}
