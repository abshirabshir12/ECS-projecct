variable "subnet_ids" {
  type = list(string)
}

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
  type = string
}

variable "container_memory" {
  type = string
}

variable "container_cpu" {
  type = string
}

variable "policy_arn" {
  type = string
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
  type = string
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
}

variable "ecr_repo_url" {
  type = string
}