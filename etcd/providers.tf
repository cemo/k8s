provider "aws" {
  region = "${data.terraform_remote_state.vpc.region}"
}
