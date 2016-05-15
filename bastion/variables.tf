variable "region" {}
variable "environment" {}
variable "s3_region" {}
variable "s3_bucket" {}

variable "ami_id" {
  default = {
    dev = "ami-e711f88a"
    test = "ami-e711f88a"
    stge = "ami-e711f88a"
    prod = "ami-e711f88a"
  }
}

variable "ssh_access_list" {
  default = "82.132.237.236/32"
}
