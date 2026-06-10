variable "ami_id" {
  description = "AMI ID for the bastion host"
  default     = "ami-01a5ce85fe18b6321"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the bastion host"
  default     = "t3.micro"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the bastion host"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for the bastion host"
  type        = string
}


variable "key_pair_name" {
  description = "Key pair name for the bastion host"
  type        = string
}

variable "environment" {
  description = "Environment tag for the bastion host"
  default     = "dev"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM instance profile for the bastion host"
  type        = string
}
