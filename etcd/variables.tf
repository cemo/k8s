variable "region" {
  default = "us-east-1"
}
variable "environment" {}
variable "s3_region" {}
variable "s3_bucket" {}

variable "ami_id" {
  default = "ami-8d6485e0"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "node_count" {
  default = 3
}

variable "discovery_url" {}
