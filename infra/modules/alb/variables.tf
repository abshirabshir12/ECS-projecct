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
  type = string
}

variable "health_check_path" {
  type = string
}

variable "target_port" {
  type = number
}

variable "certificate_validation_ref" {
  type = any
}