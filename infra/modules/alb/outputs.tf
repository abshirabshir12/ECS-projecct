output "dns_name" {
  value = aws_lb.this.dns_name
}

output "zone_id" {
  value       = aws_lb.this.zone_id
}

output "target_group_arn" {
  value = aws_lb_target_group.this.arn
}

output "waf_arn" {
  value = aws_wafv2_web_acl.this.arn
}


output "alb_logs_bucket" {
  value = aws_s3_bucket.alb_logs.bucket
}

output "kms_key_arn" {
  value = aws_kms_key.alb_logs.arn
}
