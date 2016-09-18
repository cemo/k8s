variable "remote_state_region" {}

variable "remote_state_bucket" {}

variable "name" {}

variable "environment" {}

variable "region" {
  default = {
    dev = "eu-west-1"
  }
}

variable "coreos_ami_id" {
  default = {
    eu-west-1 = "ami-e3d6ab90"
  }
}

variable "k8s_version" {
  default = "1.3.7"
}

variable "pod_network" {
  default = "10.2.0.0/16"
}

variable "service_ip_range" {
  default = "10.3.0.0/24"
}

variable "master_instance_type" {
  default = {
    dev = "m3.medium"
  }
}

variable "worker_instance_type" {
  default = {
    dev = "t2.small"
  }
}

variable "key_name" {
  default = {
    dev = "k8s-dev"
  }
}

variable "desired_workers" {
  default = {
    dev = 1
  }
}

variable "min_workers" {
  default = {
    dev = 1
  }
}

variable "max_workers" {
  default = {
    dev = 3
  }
}

variable "kubectl_config" {
  default = 1
}
