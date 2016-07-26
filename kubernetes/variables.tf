variable "region" {
  default = "us-east-1"
}
variable "environment" {}
variable "s3_region" {}
variable "s3_bucket" {}

variable "ami_id" {
  default = "ami-368c0321"
}

variable "k8s_version" {
  default = "1.3.2"
}

variable "pod_network" {
  default = "10.2.0.0/16"
}

variable "service_ip_range" {
  default = "10.3.0.0/24"
}

variable "key_path" {
  default = "/Users/anton/keys"
}

variable "master_instance_type" {
  default = "t2.medium"
}

variable "worker_instance_type" {
  default = "t2.micro"
}

variable "desired_workers" {
  default = 2
}

variable "min_workers" {
  default = 2
}

variable "max_workers" {
  default = 2
}
