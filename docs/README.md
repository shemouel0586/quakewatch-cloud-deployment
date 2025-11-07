
# QuakeWatch – Cloud Deployment with k3s & Terraform

This repo provisions a small AWS environment with Terraform (VPC, subnet, SG, EC2) and installs **k3s** on the EC2 via `user_data`. A demo nginx app is exposed on **NodePort 30080**.

## Prerequisites
- Terraform >= 1.5
- AWS credentials with EC2/VPC permissions (AdministratorAccess is fine for a lab)
- An existing EC2 key pair (default name: `quakewatch-key`) in the chosen region
- AWS CLI configured (`aws configure`) and reachable

## How to deploy
```bash
cd terraform
terraform init
terraform plan -var 'key_name=quakewatch-key' -var 'instance_type=t3.small'   # or t4g.small for ARM
terraform apply -auto-approve -var 'key_name=quakewatch-key' -var 'instance_type=t3.small'
```

> If you prefer ARM/Graviton, use an ARM instance (e.g. `t4g.small`) and change the AMI data source to filter for arm64.

## Outputs
After apply, Terraform prints:
- Public IP of the instance
- SSH command
- Demo app URL: `http://<IP>:30080`

Test it:
```bash
curl http://<IP>:30080
```

## Using kubectl against k3s
SSH to the instance:
```bash
ssh -i ./quakewatch-key.pem ec2-user@<IP>
sudo kubectl get nodes
sudo kubectl get pods -A
sudo cat /etc/rancher/k3s/k3s.yaml
```
Copy that kubeconfig locally, replace `127.0.0.1` with the EC2 public IP, and export:
```bash
export KUBECONFIG=~/kubeconfig-k3s.yaml
kubectl get nodes
```

## Clean up
```bash
cd terraform
terraform destroy -auto-approve
```

## Notes
- Security group currently allows NodePort range and 0.0.0.0/0 SSH for convenience—tighten for production.
- AMI is filtered for **x86_64**. If you use a Graviton instance family, change the AMI filter to `arm64` and set `instance_type=t4g.small` (for example).
