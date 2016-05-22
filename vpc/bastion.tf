resource "aws_instance" "bastion" {
  subnet_id = "${aws_subnet.public.0.id}"
  ami = "${var.bastion_ami_id}"
  instance_type = "${var.bastion_instance_type}"
  key_name = "${var.environment}"
  vpc_security_group_ids = [
    "${aws_security_group.bastion_public.id}"
  ]
  tags {
    Name = "bastion-${var.environment}"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "bastion_public" {
  name = "bastion-public-${var.environment}"
  vpc_id = "${aws_vpc.main.id}"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "bastion-public-${var.environment}"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "bastion_private" {
  name = "bastion-private-${var.environment}"
  vpc_id = "${aws_vpc.main.id}"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [
      "${aws_security_group.bastion_public.id}"
    ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "bastion-private-${var.environment}"
    Environment = "${var.environment}"
  }
}

resource "aws_route53_record" "bastion" {
  zone_id = "${aws_route53_zone.public.zone_id}"
  name = "bastion"
  type = "A"
  ttl = "60"
  records = ["${aws_instance.bastion.public_ip}"]
}
