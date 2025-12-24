variable "project_name" {
  default = "ECS-projecct"
}

variable "aws_region" {
  type        = string
  default = "eu-west-2"
}

 variable "vpc_name" {
   type = string
   default = "ECS" 
 }

 variable "vpc_cidr" {
   type = string
   default = "10.0.0.0/16"
 }

variable "cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type = list(string)
  default = [ "10.0.1.0/24", "10.0.2.0/24" ]
}

variable "private_subnet_cidrs" {
  type = list(string)
  default = [ "10.0.101.0/24", "10.0.102.0/24" ]
}

variable "azs" {
  type = list(string)
  default = [ "eu-west-2a", "eu-west-2b" ]
}

variable "allowed_ips" {
  type = list(string)
  default = [ "0.0.0.0/0" ]  
}

variable "iam_name" {
   type = string
   default = "ECS-threat-tool"
}

variable "instance_type" {
  description = "EC2 instance type"
  type = string
  default = "t3.micro"
}

variable "domain_name" {
  description = "domain name for application"
  type = string
  default = "lab.abshirabshir.co.uk"
}

variable "Environment_name" {
  description = "Environment name"
  type = string
  default = "dev"
}
variable "container_port" {
  type = number
  default = 3000
}

variable "container_cpu" {
  type = number
  default = 256
}

variable "container_memory" {
  type = number
  default = 512
}

variable "hosted_zone_id" {
  type = string
  default = "Z0420365QZU98VBUGSGV"
}

variable "desired_count" {
  type = number
  default = 1
}

variable "github_repo" {
  type = string
  default = "ECS-projecct"
}

variable "policy_arn" {
  type = string
  default = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

variable "ttl" {
  type = number
  default = 300
}
 

variable "target_port" {
  type = number
  default = 80
}

variable "image_tag" {
  description = "Docker image tag to use for ECS task definition (defaults to 'latest')"
  type        = string
  default     = "latest"
}

variable "log_retention_days" {
  type = number
  default = 7
}

variable "subject_alternative_names" {
  type = list(string)
  default = []
}
