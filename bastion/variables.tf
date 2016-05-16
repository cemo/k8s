variable "region" {}
variable "environment" {}
variable "s3_region" {}
variable "s3_bucket" {}

variable "ami_id" {
  default = {
    dev  = "ami-4b628b26"
    test = "ami-4b628b26"
    stge = "ami-4b628b26"
    prod = "ami-4b628b26"
  }
}

variable "ssh_access_list" {
  default = "82.132.245.10/32"
}
