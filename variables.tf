variable "aws_region" {
  default = "ap-south-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
}

variable "private_subnet2_cidr"{
  default = "10.0.3.0/24"
}

#variable "my_ip" {
#  description = "Your public IP for SSH"
#}

variable "instance_type" {
  default = "t3.medium"
}

variable "key_name" {
  description = "AWS Key Pair Name"
}

variable "db_username" {}
variable "db_password" {
  sensitive = true
}

variable "db_name" {
  default = "bookstore"
}