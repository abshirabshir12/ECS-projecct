resource "aws_security_group" "alb" {
  name        = "ecs_alb"
  description = "Security group for public ALB"
  vpc_id      = var.vpc_id

  tags = {
    Name = "ecs_alb_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http_80" {
  description = "allow http for 80-443 redirect"
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "10.0.0.0/16"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "alb_http_443" {
  description = "allows https to alb"
  security_group_id = aws_security_group.alb.id
  cidr_ipv6         = "::/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "alb_egress_all" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow outbound traffic to VPC"
  cidr_ipv4         = "10.0.0.0/16"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_security_group" "svc" {
  name = "svc"
  vpc_id = var.vpc_id
  description = "sg to ecs"

  tags = {
    Name  = "ecs_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "svc_alb_3000" {
  description = "allow alb tasks on app"
  security_group_id = aws_security_group.svc.id
  referenced_security_group_id = aws_security_group.alb.id
  from_port         = 3000
  ip_protocol       = "tcp"
  to_port           = 3000
}

resource "aws_vpc_security_group_egress_rule" "svc_egress_all" {
  security_group_id = aws_security_group.svc.id
  description       = "Allow outbound internet access from ECS service"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}

resource "aws_wafv2_web_acl_association" "alb" {
  resource_arn = aws_lb.this.arn
  web_acl_arn  = aws_wafv2_web_acl.this.arn
}
