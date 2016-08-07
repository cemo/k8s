variable "region" {
  default = "us-east-1"
}
variable "environment" {}
variable "s3_region" {}
variable "s3_bucket" {}

variable "ami_id" {
  default = "ami-edc744fa"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "cluster_size" {
  default = 3
}
