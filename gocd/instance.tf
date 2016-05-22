resource "aws_instance" "gocd" {
  ami = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  subnet_id = "${element(split(",", terraform_remote_state.vpc.output.public_subnet_ids), 0)}"
  key_name = "${var.environment}"
  iam_instance_profile = "${aws_iam_instance_profile.gocd.id}"
  vpc_security_group_ids = [
    "${terraform_remote_state.vpc.output.bastion_sg_id}",
    "${aws_security_group.gocd.id}"
  ]
  tags {
    Name = "gocd-${var.environment}"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "gocd" {
  name = "gocd-${var.environment}"
  vpc_id = "${terraform_remote_state.vpc.output.id}"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "gocd-${var.environment}"
    Environment = "${var.environment}"
  }
}
