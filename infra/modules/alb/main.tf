resource "aws_lb" "this" {
  name               = var.project_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_sg_ids
  subnets            = var.public_subnet_ids

  enable_deletion_protection = true
    enable_http2               = true
  drop_invalid_header_fields = true  # CKV_AWS_131
  access_logs {
    bucket  = var.alb_logs_bucket
    prefix  = "${var.project_name}/alb"
    enabled = true                # CKV_AWS_91
  }

  tags = {
    name = "${var.project_name}-alb-lb"
  }
}

resource "aws_lb_target_group" "this" {
  name        = "${var.project_name}-tg"
  target_type = "ip"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    path = "/status"
    interval = 30
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
    matcher = "200"
  }
  tags = {
    name = "${var.project_name}-alb-tg"
  }
}

resource "aws_lb_listener" "HTTP" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "HTTPS" {
  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_wafv2_web_acl_association" "alb_waf" {
  resource_arn = aws_lb.this.arn
  web_acl_arn  = var.waf_arn
}
