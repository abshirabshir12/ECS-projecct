output "cluster_name" {
  value = aws_ecs_cluster.ecs.name
}

output "task_defenition.app.arn" {
  value = aws_ecs_task_definition.app.arn
}

output "service_name" {
  value = aws_ecs_service.app.name
}