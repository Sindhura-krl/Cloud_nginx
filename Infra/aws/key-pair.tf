resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "terraform-generated-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}
output "private_key_pem" {
  value     = tls_private_key.ec2_key.private_key_pem
  sensitive = true
}


