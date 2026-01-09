data "aws_route53_zone" "primary" {
  zone_id = var.hosted_zone_id
}

resource "aws_route53_record" "alb" {
  zone_id         = var.hosted_zone_id
  name            = var.domain_name
  type            = "A"
  allow_overwrite = true

  alias {
    name                   = var.dns_name
    zone_id                = var.zone_id
    evaluate_target_health = true
  }
}