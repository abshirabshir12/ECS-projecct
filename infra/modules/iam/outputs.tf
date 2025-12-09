output "ecs_execution_role_arn" {
  description = "arn of ecs execution"
  value = aws_iam_role.ecs_execution.arn
}

output "ecs_task_role_arn" {
  description = "arn of the ecs task"
  value = aws_iam_role.ecs_task.arn
}