resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "hcloud_ssh_key" "this" {
  name       = var.name
  public_key = tls_private_key.this.public_key_openssh
}
