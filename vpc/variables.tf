variable "remote_state_region" {}

variable "remote_state_bucket" {}

variable "name" {}

variable "environment" {}

variable "region" {
  default = {
    dev = "eu-west-1"
  }
}

variable "account_id" {
  default = {
    dev = "323333154476"
  }
}

variable "vpc_cidr_block" {
  default = {
    dev = "10.0.0.0/16"
  }
}

variable "max_az_count" {
  default = 3
}

variable "domain" {
  default = "dev-kat.co.uk"
}

variable "domain_env_prefix" {
  default = {
    dev = "dev."
  }
}

variable "domain_hosted_zone_id" {
  default = {
    dev = "Z25XM7MZD1U2CS"
  }
}
