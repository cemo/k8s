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

variable "vpc_cidr_block" {
  default = "10.100.0.0/16"
}

variable "availability_zones" {
  default = "a,b,d"
}

variable "bastion_ami_id" {
  default = "ami-368c0321"
}

variable "bastion_instance_type" {
  default = "t2.nano"
}

variable "home_ip" {
  default = "80.229.27.83"
}

variable "kubernetes_cluster" {
  default = "devscape"
}
