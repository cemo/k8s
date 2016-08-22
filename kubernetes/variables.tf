variable "environment" {}
variable "s3_region" {}
variable "s3_bucket" {}

variable "ami_id" {
  default = {
    eu-west-1 = "ami-b7cba3c4"
    us-east-1 = "ami-6d138f7a"
  }
}

variable "k8s_version" {
  default = "1.3.5"
}

variable "pod_network" {
  default = "10.2.0.0/16"
}

variable "service_ip_range" {
  default = "10.3.0.0/24"
}

variable "master_instance_type" {
  default = "m3.medium"
}

variable "worker_instance_type" {
  default = "t2.small"
}

variable "desired_workers" {
  default = 1
}

variable "min_workers" {
  default = 1
}

variable "max_workers" {
  default = 3
}
