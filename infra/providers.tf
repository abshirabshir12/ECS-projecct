terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.19.0"
    }
  }
}
terraform {
  backend "s3" {
   bucket      = "ecs-threat-tool-bucket"
   key = "ecs-threat-tool/terraform.tfstate"
  }
}
provider "aws" {
  region = var.aws_region
}