# Get the latest Ubuntu 22.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Local variable for instances
locals {
  instances = {
    "app" = {
      subnet_id         = module.vpc.public_subnets[0]
      security_group_id = aws_security_group.PublicSG.id
    }
    "tools" = {
      subnet_id         = module.vpc.public_subnets[1]
      security_group_id = aws_security_group.PublicSG.id
    }
  }
}

# EC2 instances
module "ec2_instance" {
  for_each = local.instances
  source   = "terraform-aws-modules/ec2-instance/aws"

  name = each.key

  instance_type          = "t2.medium"
  ami                    = data.aws_ami.ubuntu.id
  key_name               = aws_key_pair.generated_key.key_name
  monitoring             = true
  vpc_security_group_ids = [each.value.security_group_id]
  subnet_id              = each.value.subnet_id

  # This enables temporary public IP until Elastic IP is attached
  associate_public_ip_address = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# Elastic IPs
resource "aws_eip" "app" {
  tags = {
    Name = "app-eip"
  }
}

resource "aws_eip" "tools" {
  tags = {
    Name = "tools-eip"
  }
}

# Associate Elastic IPs with EC2 instances
resource "aws_eip_association" "app_assoc" {
  instance_id   = module.ec2_instance["app"].id
  allocation_id = aws_eip.app.id
}

resource "aws_eip_association" "tools_assoc" {
  instance_id   = module.ec2_instance["tools"].id
  allocation_id = aws_eip.tools.id
}

# Outputs
output "app_eip" {
  value = aws_eip.app.public_ip
}

output "tools_eip" {
  value = aws_eip.tools.public_ip
}
