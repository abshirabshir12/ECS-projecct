resource "aws_wafv2_web_acl" "alb" {
  name  = "${var.project_name}-alb-waf"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  # 🔴 REQUIRED (ACL-level)
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "alb-waf"
    sampled_requests_enabled   = true
  }

  rule {
  name     = "AWSManagedRulesKnownBadInputsRuleSet"
  priority = 2

  override_action {
    none {}
  }

  statement {
    managed_rule_group_statement {
      name        = "AWSManagedRulesKnownBadInputsRuleSet"
      vendor_name = "AWS"
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "bad-inputs"
    sampled_requests_enabled   = true
  }
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

    # 🔴 REQUIRED (RULE-level)
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "common-rule-set"
      sampled_requests_enabled   = true
    }
  }
}

resource "aws_wafv2_web_acl_association" "alb" {
  resource_arn = aws_lb.this.arn
  web_acl_arn  = aws_wafv2_web_acl.alb.arn
}

resource "aws_cloudwatch_log_group" "waf" {
  name              = "/aws/waf/${var.project_name}"
  retention_in_days = 30
}
