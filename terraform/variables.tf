
variable "aws_region"          { type = string  default = "us-east-1" }
variable "vpc_cidr"            { type = string  default = "10.10.0.0/16" }
variable "public_subnet_cidr"  { type = string  default = "10.10.1.0/24" }
variable "instance_type"       { type = string  default = "t3.small" }
variable "key_name"            { type = string  description = "Existing EC2 key pair name" }
variable "allow_ssh_cidr"      { type = string  default = "0.0.0.0/0" } # tighten in real use
