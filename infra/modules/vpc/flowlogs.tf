resource "aws_flow_log" "vpc" {
  vpc_id = aws_vpc.main.id
  traffic_type = "ALL"
  log_destination_type = "cloud-watch-logs"
  log_destination = aws_cloudwatch_log_group.vpc.arn
  iam_role_arn = aws_iam_role.flow_logs.arn
}
