
# Latest Amazon Linux 2023 AMI
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["137112412989"] # Amazon
  filter { name = "name" values = ["al2023-ami-*-kernel-6.1-*"] }
}

# (Optional) Simple user_data that installs nginx to test connectivity
locals {
  user_data = <<-EOF
    #!/bin/bash
    dnf install -y nginx
    systemctl enable --now nginx
    echo "<h1>QuakeWatch EC2 alive</h1>" > /usr/share/nginx/html/index.html
  EOF
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_a.id
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  associate_public_ip_address = true
  key_name                    = var.key_name
  user_data                   = local.user_data

  tags = { Name = "qw-ec2" }
}
