
output "ec2_public_ip" {
  value = aws_instance.web.public_ip
}

output "ssh_command" {
  value = "ssh -i ./<your-key>.pem ec2-user@${aws_instance.web.public_ip}"
}

output "test_url" {
  value = "http://${aws_instance.web.public_ip}"
}
