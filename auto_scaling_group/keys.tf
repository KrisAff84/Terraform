resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "local_file" "private_key_pem" {
  content  = tls_private_key.key.private_key_pem
  filename = "${var.key_name}.pem"
}

resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = tls_private_key.key.public_key_openssh
}