data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    region = "${var.remote_state_region}"
    bucket = "${var.remote_state_bucket}"
    key    = "${var.name}/${var.environment}/vpc.tfstate"
  }
}
