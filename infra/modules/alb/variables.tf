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
variable "alb_sg_ids" {
  description = "Security group ID for the ALB"
  type        = list(string)
}

variable "alb_logs_bucket" {
  type = string
}

variable "waf_arn" {
  type = string
}