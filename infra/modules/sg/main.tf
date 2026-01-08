 #checkov:skip=CKV2_AWS_5: Security group attached in ALB module
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



