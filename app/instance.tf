resource "aws_instance" "ubuntu" {
  ami = "ami-fce3c696"
  subnet_id = "${element(split(",", terraform_remote_state.vpc.output.private_subnet_ids), 0)}"
  instance_type = "t2.nano"
  key_name = "${var.environment}"
  vpc_security_group_ids = [
    "${terraform_remote_state.vpc.output.bastion_security_group_id}"
  ]
  tags {
    Name = "ubuntu"
  }
}
