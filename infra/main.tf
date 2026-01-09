terraform {
  required_version = ">= 1.6.0"

  backend "s3" {
    bucket       = "ecs-terra-bucket"
    key          = "infrastructure/terraform.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
    encrypt      = true
  }
}

module "vpc" {
  source               = "./modules/vpc"
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  vpc_cidr             = var.vpc_cidr

}

module "sg" {
  source       = "./modules/sg"
  vpc_id       = module.vpc.vpc_id
  vpc_cidr     = var.vpc_cidr
  project_name = var.project_name
  environment  = var.Environment_name
}

module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name
  github_repo  = var.github_repo
  policy_arn   = var.policy_arn
  cluster_name = var.cluster_name

}

module "acm" {
  source       = "./modules/acm"
  domain_name  = var.domain_name
  project_name = var.project_name
  zone_id      = var.hosted_zone_id
  ttl          = var.ttl
}

module "alb" {
  source            = "./modules/alb"
  project_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  certificate_arn   = module.acm.certificate_arn
  alb_sg_ids        = [module.sg.alb_sg_id]
  waf_arn           = module.alb.waf_arn
  alb_logs_bucket   = module.alb.alb_logs_bucket
}

module "route53" {
  source         = "./modules/route53"
  domain_name    = var.domain_name
  hosted_zone_id = var.hosted_zone_id
  dns_name       = module.alb.dns_name
  zone_id        = module.alb.zone_id

}

module "ecs" {
  source             = "./modules/ecs"
  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  enviroment         = var.Environment_name
  alb_sg_ids         = module.sg.alb_sg_id
  aws_region         = var.aws_region
  log_retention_days = var.log_retention_days
  container_memory   = var.container_memory
  desired_count      = var.desired_count
  container_cpu      = var.container_cpu
  container_port     = var.container_port
  execution_arn      = module.iam.ecs_execution_role_arn
  target_group_arn   = module.alb.target_group_arn
  task_arn           = module.iam.ecs_task_role_arn
  ecr_repo_url       = module.ecr.repository_url
  private_subnet_ids = module.vpc.private_subnet_ids
  ecs_sg_id          = module.ecs.ecs_sg_id
  kms_key_arn        = module.alb.kms_key_arn

}

module "ecr" {
  source       = "./modules/ecr"
  project_name = var.project_name
  kms_key_arn  = module.alb.kms_key_arn
}