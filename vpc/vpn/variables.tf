variable "environment" {}

variable "ami_id" {
  default = "ami-38a3292f"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "access_list" {
  default = [
    "80.229.27.83/32"
  ]
}

variable "vpc_id" {}

variable "public_subnet_ids" {
  type = "list"
}

variable "public_zone_id" {}

variable "on_off" {
  default = 0
}
