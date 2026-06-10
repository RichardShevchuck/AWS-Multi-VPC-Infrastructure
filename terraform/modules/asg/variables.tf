variable "max_size" {
  description = "Maximum number of instances in the Auto Scaling group"
  default     = 4
  type        = number
}

variable "min_size" {
  description = "Minimum number of instances in the Auto Scaling group"
  default     = 2
  type        = number
}

variable "desired_capacity" {
  description = "Desired number of instances in the Auto Scaling group"
  default     = 2
  type        = number
}


variable "launch_template_id" {
  description = "Launch template ID for the Auto Scaling group"
  type        = string
}

variable "environment" {
  description = "Environment tag for the Auto Scaling group"
  default     = "dev"
  type        = string
}


variable "subnet_ids" {
  description = "List of subnet IDs for the Auto Scaling group"
  type        = list(string)
}
