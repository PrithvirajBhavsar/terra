variable "aws_region" {
  type        = string
  description = "AWS region for infrastructure deployment"
  default     = "ap-south-1"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}