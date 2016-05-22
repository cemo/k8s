variable "region" {
  default = "us-east-1"
}
variable "environment" {}
variable "s3_region" {}
variable "s3_bucket" {}

variable "public_domain" {
  default = "devscape.io"
}

variable "private_domain" {
  default = "devscape.private"
}

variable "domain_hosted_zone_id" {
  default = "Z6SB6MX6NJNME"
}

variable "vpc_cidr_block" {}

variable "availability_zones" {
  default = "a,b,d"
}

variable "bastion_ami_id" {
  default = "ami-fce3c696"
}

variable "bastion_instance_type" {
  default = "t2.micro"
}
