provider "aws" {
  region = "${var.region[var.environment]}"
}
