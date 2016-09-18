variable "name" {}

variable "environment" {}

variable "region" {}

variable "vpc_id" {}

variable "vpc_cidr_block" {}

variable "subnet_ids" {
  type = "list"
}

variable "hosted_zone_id" {}

variable "ssh_security_group_ids" {
  type = "list"
}

variable "coreos_ami_id" {
  default = {
    eu-west-1 = "ami-e3d6ab90"
  }
}

variable "instance_type" {
  default = {
    dev = "t2.micro"
  }
}

variable "cluster_size" {
  default = {
    dev = 3
  }
}

variable "key_name" {
  default = {
    dev = "k8s-dev"
  }
}
