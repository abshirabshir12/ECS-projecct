resource "aws_kms_key" "waf" {
  description         = "KMS key for WAF logs"
  enable_key_rotation = true
}

resource "aws_kms_alias" "waf" {
  name          = "alias/waf-logs"
  target_key_id = aws_kms_key.waf.id
}
