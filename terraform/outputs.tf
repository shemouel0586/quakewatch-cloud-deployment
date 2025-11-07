
output "master_public_ip" {
  value = aws_instance.web.public_ip
}

output "ssh_command" {
  value = "ssh -i ./quakewatch-key.pem ec2-user@${aws_instance.web.public_ip}"
}

output "demo_app_url" {
  value       = "http://${aws_instance.web.public_ip}:30080"
  description = "Reach the nginx demo exposed via NodePort"
}
