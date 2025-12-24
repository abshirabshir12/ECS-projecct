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