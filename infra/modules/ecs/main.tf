resource "aws_security_group" "ecs_sg" {
  name        = "${var.project_name}-ecs-sg"
  vpc_id      = var.vpc_id

 ingress {
    description = "http from alb"
    from_port = var.container_port
    to_port = var.container_port
    protocol = "tcp"
    security_groups = [ var.alb_sg_ids ]
}

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

 tags = {
    name ="${var.project_name}-ecs-sg"
  }
}

resource "aws_ecs_cluster" "ecs" {
  name = "${var.project_name}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "app" {
  family = "${var.project_name}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  execution_role_arn       = var.execution_arn
  task_role_arn            = var.task_arn
    
  container_definitions = jsonencode([
    {
      name      = "app"
      image     = "${var.ecr_repo_url}:${var.image_tag}"
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"   
        }
      }
    },
  ])
}

resource "aws_ecs_service" "app" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.ecs.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.desired_count
  launch_type = "FARGATE"

  network_configuration {
    subnets = var.subnet_ids
    security_groups = [ aws_security_group.ecs_sg.id ]
    assign_public_ip = false 
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "app"
    container_port   = var.container_port
  }
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name = "${var.project_name}-ecs-logs"
  retention_in_days = var.log_retention_days
}