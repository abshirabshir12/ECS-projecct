variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "cidr_ipv4" {
  default = "0.0.0.0/0"
  description = "Cidr block for ipv4"
  type = number
}

variable "http_port" {
  default = 80
  description = "value for http port"
  type = number
}

variable "ssh_port" {
  default = 22
  description = "value for ssh port"
  type = number
}

variable "ip_protocol_tcp" {
  default = "-1"
  description = "value is -1"
  type = number
}



variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}