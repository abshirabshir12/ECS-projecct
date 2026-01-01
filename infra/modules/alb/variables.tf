variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "certificate_arn" {
  type = string
}
variable "alb_sg_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "alb_logs_bucket" {
  type = string
}