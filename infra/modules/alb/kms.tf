data "aws_caller_identity" "current" {}

resource "aws_kms_key" "waf" {
  description         = "KMS key for WAF logs"
  enable_key_rotation = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EnableRootPermissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "AllowCloudWatchLogs"
        Effect = "Allow"
        Principal = {
          Service = "logs.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_kms_alias" "waf" {
  name          = "alias/waf-logs"
  target_key_id = aws_kms_key.waf.id
}

resource "aws_s3_bucket" "alb_logs" {
  bucket = lower("${var.project_name}-alb-logs")
  force_destroy = true
}

resource "aws_kms_key" "alb_logs" {
  description = "KMS key for ALB logs"
}
