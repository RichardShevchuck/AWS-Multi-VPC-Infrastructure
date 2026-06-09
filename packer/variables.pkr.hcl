variable "aws_region" {
  type        = string
  default     = "us-east-2"
  description = "The AWS region where the AMI will be built."
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "The environment for the AMI (e.g., dev, test, prod)."
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "The instance type to use for the AMI."
}

variable "ami_name" {
  type        = string
  default     = "golden-ami"
  description = "The name of the AMI to be created."
}
