variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_profile" { type = string  default = "default" }


variable "vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.10.1.0/24"
}

variable "instance_type" {
  type    = string
  default = "t3.small"
}

# Set this to an existing EC2 key pair name in your region
variable "key_name" {
  type        = string
  description = "EC2 key pair name"
}

variable "allow_ssh_cidr" {
  type    = string
  default = "0.0.0.0/0" # tighten in real use
}
