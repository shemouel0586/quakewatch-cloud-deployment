
# X86_64 AMI for Amazon Linux 2023 (preferred if instance_type is t3.*, m5.*, etc.)
data "aws_ami" "al2023_x86_64" {
  most_recent = true
  owners      = ["137112412989"]

  filter { name = "name"                values = ["al2023-ami-*-x86_64*"] }
  filter { name = "architecture"        values = ["x86_64"] }
  filter { name = "virtualization-type" values = ["hvm"] }
  filter { name = "root-device-type"    values = ["ebs"] }
}

# Optional k3s install + demo NodePort via user_data
locals {
  user_data = <<-EOF
    #!/bin/bash
    set -euo pipefail
    dnf install -y curl
    # Install k3s server and make kubeconfig world-readable (lab only)
    curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --write-kubeconfig-mode=644" sh -
    # Simple demo app (nginx via NodePort)
    cat >/tmp/qw-demo.yaml <<'YAML'
    apiVersion: v1
    kind: Namespace
    metadata: { name: quakewatch }
    ---
    apiVersion: apps/v1
    kind: Deployment
    metadata: { name: qw-web, namespace: quakewatch }
    spec:
      replicas: 1
      selector: { matchLabels: { app: qw-web } }
      template:
        metadata: { labels: { app: qw-web } }
        spec:
          containers:
          - name: web
            image: nginx:stable
            ports: [{ containerPort: 80 }]
    ---
    apiVersion: v1
    kind: Service
    metadata: { name: qw-svc, namespace: quakewatch }
    spec:
      type: NodePort
      selector: { app: qw-web }
      ports:
      - port: 80
        targetPort: 80
        nodePort: 30080
    YAML
    /var/lib/rancher/k3s/bin/kubectl apply -f /tmp/qw-demo.yaml
  EOF
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.al2023_x86_64.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_a.id
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  associate_public_ip_address = true
  key_name                    = var.key_name
  user_data                   = local.user_data

  tags = { Name = "qw-ec2" }
}
