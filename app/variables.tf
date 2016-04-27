variable "s3_region" {}
variable "s3_bucket" {}
variable "environment" {}

variable "region" {
  default = {
    dev  = "us-east-1"
    test = "us-east-1"
    stge = "us-east-1"
    prod = "us-east-1"
  }
}
