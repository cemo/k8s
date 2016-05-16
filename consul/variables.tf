variable "region" {}
variable "environment" {}
variable "s3_region" {}
variable "s3_bucket" {}

variable "ami_id" {
  default = "ami-4b628b26"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "node_count" {
  default = 3
}
