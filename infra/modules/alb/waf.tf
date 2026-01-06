
resource "aws_wafv2_web_acl_association" "alb" {
  resource_arn = aws_lb.this.arn
  web_acl_arn  = aws_wafv2_web_acl.alb.arn
}

resource "aws_cloudwatch_log_group" "waf" {
  name              = "/aws/waf/${var.project_name}"
  retention_in_days = 365   

  kms_key_id = aws_kms_key.waf.arn  
}

resource "aws_wafv2_web_acl_logging_configuration" "alb" {
  resource_arn = aws_wafv2_web_acl.alb.arn

  log_destination_configs = [
    aws_cloudwatch_log_group.waf.arn
  ]
}


