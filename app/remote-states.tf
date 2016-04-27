resource "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    bucket = "${var.s3_bucket}"
    key = "${var.environment}/vpc.tfstate"
    region = "${var.s3_region}"
  }
}
