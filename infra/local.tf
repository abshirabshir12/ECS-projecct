locals {
  common_tags  = {
    Project    = var.project_name
    Environment = var.Environment_name
    Availability_zones = var.azs
    public_subnet_cidrs = var.public_subnet_cidrs
    private_subnet_cidrs = var.private_subnet_cidrs
    cidr_block = var.cidr_block
    Managedby  = "Terraform"
  }
}