resource "tls_private_key" "ca" {
  algorithm = "RSA"
  rsa_bits  = "2048"

  lifecycle {
    create_before_destroy = true
  }
}

resource "tls_self_signed_cert" "ca" {
  key_algorithm   = "${tls_private_key.ca.algorithm}"
  private_key_pem = "${tls_private_key.ca.private_key_pem}"

  subject {
    common_name = "kube-ca"
  }

  validity_period_hours = 87600

  allowed_uses = []

  early_renewal_hours = 720
  is_ca_certificate   = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "tls_private_key" "apiserver" {
  algorithm = "RSA"
  rsa_bits  = "2048"

  lifecycle {
    create_before_destroy = true
  }
}

data "tls_cert_request" "apiserver" {
  key_algorithm   = "${tls_private_key.apiserver.algorithm}"
  private_key_pem = "${tls_private_key.apiserver.private_key_pem}"

  subject {
    common_name = "kube-apiserver"
  }

  dns_names = [
    "kubernetes",
    "kubernetes.default",
    "kubernetes.default.svc",
    "kubernetes.default.svc.cluster.local",
    "master.${data.terraform_remote_state.vpc.private_domain_name}",
  ]

  ip_addresses = [
    "${cidrhost(var.service_ip_range, 1)}",
  ]
}

resource "tls_locally_signed_cert" "apiserver" {
  cert_request_pem      = "${data.tls_cert_request.apiserver.cert_request_pem}"
  ca_key_algorithm      = "${tls_private_key.ca.algorithm}"
  ca_private_key_pem    = "${tls_private_key.ca.private_key_pem}"
  ca_cert_pem           = "${tls_self_signed_cert.ca.cert_pem}"
  validity_period_hours = 8760

  allowed_uses = [
    "any_extended",
    "nonRepudiation",
    "digitalSignature",
    "keyEncipherment",
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "tls_private_key" "admin" {
  algorithm = "RSA"
  rsa_bits  = "2048"

  lifecycle {
    create_before_destroy = true
  }
}

data "tls_cert_request" "admin" {
  key_algorithm   = "${tls_private_key.admin.algorithm}"
  private_key_pem = "${tls_private_key.admin.private_key_pem}"

  subject {
    common_name = "kube-admin"
  }
}

resource "tls_locally_signed_cert" "admin" {
  cert_request_pem      = "${data.tls_cert_request.admin.cert_request_pem}"
  ca_key_algorithm      = "${tls_private_key.ca.algorithm}"
  ca_private_key_pem    = "${tls_private_key.ca.private_key_pem}"
  ca_cert_pem           = "${tls_self_signed_cert.ca.cert_pem}"
  validity_period_hours = 8760
  allowed_uses          = []

  lifecycle {
    create_before_destroy = true
  }
}
