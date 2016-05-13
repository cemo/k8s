variable "region" {}
variable "environment" {}
variable "s3_region" {}
variable "s3_bucket" {}

variable "ami_id" {
  default = {
    dev  = "ami-fce3c696"
    test = "ami-fce3c696"
    stge = "ami-fce3c696"
    prod = "ami-fce3c696"
  }
}

variable "ssh_access_list" {
  default = "82.132.237.236/32"
}
