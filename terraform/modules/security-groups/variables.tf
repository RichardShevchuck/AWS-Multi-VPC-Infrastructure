variable "cidr_block_ingress" {
  type        = string
  default     = "0.0.0.0/0"
  description = "CIDR block for the security group ingress rule."
}

variable "cidr_block_egress" {
  type        = string
  default     = "0.0.0.0/0"
  description = "CIDR block for the security group egress rule."
}

variable "vpc_bastion" {
  type        = string
  description = "The ID of the VPC where the bastion host is located."
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment for the security groups."
}

variable "vpc_alb" {
  type        = string
  description = "The ID of the VPC where the ALB is located."
}

variable "vpc_bastion_cidr" {
  type    = string
  default = "192.168.1.0/24"
}
