#checkov:skip=CKV2_AWS_76: WAF rules managed outside Terraform
resource "aws_wafv2_web_acl" "this" {
  name  = "${var.project_name}-waf"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "alb-waf"
    sampled_requests_enabled   = true
  }
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }


    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "common"
      sampled_requests_enabled   = true
    }
  }
}




resource "aws_cloudwatch_log_group" "waf" {
  name              = "aws-waf-logs-ECS-projecct"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_resource_policy" "waf" {
  policy_name = "AWSWAFLoggingPolicy"

  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "wafv2.amazonaws.com"
        }
        Action   = "logs:PutLogEvents"
        Resource = "${aws_cloudwatch_log_group.waf.arn}:*"
      }
    ]
  })
}

resource "aws_wafv2_web_acl_logging_configuration" "alb" {
  resource_arn = aws_wafv2_web_acl.this.arn

  log_destination_configs = [
    "${aws_cloudwatch_log_group.waf.arn}:*"
  ]
}




