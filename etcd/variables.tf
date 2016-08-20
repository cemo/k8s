variable "region" {
  default = "us-east-1"
}
variable "environment" {}
variable "s3_region" {}
variable "s3_bucket" {}

variable "ami_id" {
  default = {
    eu-west-1 = "ami-b7cba3c4"
    us-east-1 = "ami-6d138f7a"
  }
}

variable "instance_type" {
  default = "t2.micro"
}

variable "cluster_size" {
  default = 3
}
