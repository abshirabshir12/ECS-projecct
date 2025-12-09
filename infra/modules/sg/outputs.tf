output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
  description = "secuirity group id for the alb"
}

output "svc_sg_id" {
  value = aws_security_group.svc.id
  description = "secuirity group id for ecs"
}