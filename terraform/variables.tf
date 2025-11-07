
variable "aws_profile" {
  description = "AWS CLI profile to use (from ~/.aws/config)."
  type        = string
  default     = "default"
}

variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.20.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.20.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type. Use t3.* for x86_64 or t4g.* for ARM."
  type        = string
  default     = "t3.small"
}

variable "key_name" {
  description = "Existing EC2 key pair name for SSH."
  type        = string
  default     = "quakewatch-key"
}

variable "allow_ssh_cidr" {
  description = "CIDR allowed to SSH to the instance. Tighten for real use."
  type        = string
  default     = "0.0.0.0/0"
}
