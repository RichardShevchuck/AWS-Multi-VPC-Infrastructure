variable "environment" {
  description = "Environment (dev, prod)"
  default     = "dev"
  type        = string
}

variable "vpc_bastion_id" {
  description = "Bastion VPC ID"
  type        = string
}

variable "vpc_bastion_subnet_id" {
  description = "Bastion public subnet ID"
  type        = string
}

variable "vpc_bastion_cidr" {
  type    = string
  default = "192.168.0.0/16"
}

variable "vpc_private_id" {
  description = "Private VPC ID"
  type        = string
}

variable "vpc_private_subnet_id" {
  description = "Private public subnet ID"
  type        = string
}

variable "vpc_private_cidr" {
  type    = string
  default = "172.32.0.0/16"
}

variable "bastion_route_table_id" {
  description = "Bastion VPC route table ID"
  type        = string
}

variable "private_route_table_id" {
  description = "Private VPC route table ID"
  type        = string
}

