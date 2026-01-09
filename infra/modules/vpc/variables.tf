variable "project_name" {
  default = "ECS-projecct"
  type    = string
}

variable "cidr_block" {
  default = "10.0.0.0/16"
  type    = string
}

variable "azs" {
  description = "list of availability zones"
  type        = list(string)
}

variable "Environment_name" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "common tags"
  type        = map(string)
  default     = {}
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "vpc_cidr" {
  type = string
}