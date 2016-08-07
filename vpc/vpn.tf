resource "aws_eip" "vpn" {
  vpc = true
}

resource "aws_route53_record" "vpn" {
  zone_id = "${aws_route53_zone.public.zone_id}"
  name = "vpn"
  type = "A"
  ttl = "60"
  records = ["${aws_eip.vpn.public_ip}"]
}

resource "aws_instance" "vpn" {
  ami = "${var.vpn_ami_id[var.region]}"
  subnet_id = "${aws_subnet.public.*.id[0]}"
  instance_type = "${var.vpn_instance_type}"
  key_name = "${var.environment}"
  source_dest_check = false
  vpc_security_group_ids = [
    "${aws_security_group.vpn.id}"
  ]
  user_data = "${data.template_file.vpn.rendered}"
  tags {
    Name = "vpn-${var.environment}"
    Environment = "${var.environment}"
  }
}

data "template_file" "vpn" {
  template = "${file("${path.module}/templates/vpn-userdata")}"
  vars {
    public_hostname = "${aws_route53_record.vpn.fqdn}"
    reroute_dns = "1"
  }
}

resource "aws_security_group" "vpn" {
  name_prefix = "vpn-${var.environment}-"
  vpc_id = "${aws_vpc.main.id}"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = "${var.vpn_access_list}"
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = "${var.vpn_access_list}"
  }
  ingress {
    from_port = 943
    to_port = 943
    protocol = "tcp"
    cidr_blocks = "${var.vpn_access_list}"
  }
  ingress {
    from_port = 1194
    to_port = 1194
    protocol = "tcp"
    cidr_blocks = "${var.vpn_access_list}"
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
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip_association" "vpn" {
  instance_id = "${aws_instance.vpn.id}"
  allocation_id = "${aws_eip.vpn.id}"
}
