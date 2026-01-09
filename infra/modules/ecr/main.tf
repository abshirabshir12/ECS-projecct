resource "aws_ecr_repository" "this" {
  name                 = "ecs-projecct-repo"
  image_tag_mutability = "IMMUTABLE"
  force_delete         = false

  image_scanning_configuration {
    scan_on_push = true
  }


  encryption_configuration {
    encryption_type = "KMS" # CKV_AWS_136
    kms_key         = var.kms_key_arn
  }

  tags = {
    Name = "${var.project_name}-ecr"
  }
}