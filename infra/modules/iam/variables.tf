variable "project_name" {
  type = string
}

variable "github_repo" {
  type = string
  default = "ECS-projecct"
}

variable "policy_arn" {
  type = string
  default = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
variable "aws_region" {
  type        = string
  default = "eu-west-2"
}

variable "account_id" {
  type = string
  default = "555569221122"
}

variable "cluster_name" {
  type = string
}