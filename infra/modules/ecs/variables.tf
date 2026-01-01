
variable "alb_sg_ids" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "container_port" {
  type = number
  default = 3000
}

variable "container_memory" {
  type = number
  default = 512
}

variable "container_cpu" {
  type = number
  default = 256
}


variable "project_name" {
  type = string
}

variable "enviroment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "desired_count" {
  type = number
  default = 1
}

variable "execution_arn" {
  type = string
}

variable "task_arn" {
  type = string
}

variable "image_tag" {
  type = string
  default = "latest"
}

variable "log_retention_days" {
  type = number
  default = 7
}

variable "ecr_repo_url" {
  type = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}
variable "kms_key_arn" {
  type = string
}