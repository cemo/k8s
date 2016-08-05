resource "aws_eip" "vpn" {
  count = "${var.on_off}"
  vpc = true
}

resource "aws_route53_record" "vpn" {
  count = "${var.on_off}"
  zone_id = "${var.public_zone_id}"
  name = "vpn"
  type = "A"
  ttl = "60"
  records = ["${aws_eip.vpn.public_ip}"]
}

resource "aws_instance" "vpn" {
  count = "${var.on_off}"
  subnet_id = "${var.public_subnet_ids[0]}"
  ami = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  key_name = "${var.environment}"
  source_dest_check = false
  vpc_security_group_ids = [
    "${aws_security_group.vpn.id}"
  ]
  user_data = "${template_file.vpn.rendered}"
  tags {
    Name = "vpn-${var.environment}"
    Environment = "${var.environment}"
  }
}

resource "template_file" "vpn" {
  count = "${var.on_off}"
  template = "${file("${path.module}/vpn-userdata")}"
  vars {
    public_hostname = "${aws_route53_record.vpn.fqdn}"
    reroute_dns = "1"
  }
}

resource "aws_security_group" "vpn" {
  count = "${var.on_off}"
  name = "vpn-${var.environment}"
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = "${var.access_list}"
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = "${var.access_list}"
  }
  ingress {
    from_port = 943
    to_port = 943
    protocol = "tcp"
    cidr_blocks = "${var.access_list}"
  }
  ingress {
    from_port = 1194
    to_port = 1194
    protocol = "tcp"
    cidr_blocks = "${var.access_list}"
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "vpn-${var.environment}"
    Environment = "${var.environment}"
  }
}

resource "aws_eip_association" "vpn" {
  count = "${var.on_off}"
  instance_id = "${aws_instance.vpn.id}"
  allocation_id = "${aws_eip.vpn.id}"
}
