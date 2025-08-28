resource "aws_security_group" "PublicSG" {
  name        = "PublicSG"
  description = "Allow inbound SSH, HTTP, Jenkins and all outbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins from anywhere"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description      = "All outbound IPv4"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    description       = "All outbound IPv6"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    ipv6_cidr_blocks  = ["::/0"]
  }

  tags = {
    Name = "PublicSG"
  }
}
