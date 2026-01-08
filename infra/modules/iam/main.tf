resource "aws_iam_role" "ecs_execution" {
  name = "${var.project_name}-ecs-execution"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
   name = "${var.project_name}-ecs-execution" 
  }
}

resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role       = aws_iam_role.ecs_execution.name
  policy_arn = var.policy_arn
}

resource "aws_iam_role" "ecs_task" {
  name = "${var.project_name}-ecs-task"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
   name = "${var.project_name}-ecs-task" 
  }
}

resource "aws_iam_role_policy" "ecs_task_logs" {
  name = "${var.project_name}ecs-task-logs"
  role = aws_iam_role.ecs_task.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
           "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:${var.aws_region}:${var.account_id}:log-group:${var.project_name}-ecs-logs:*"
      },
    ]
  })
}

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://accounts.google.com"

  client_id_list = [
    "266362248691-342342xasdasdasda-apps.googleusercontent.com",
  ]

  thumbprint_list = ["cf23df2207d99a74fbe169e3eba035e633b65d94"]

  lifecycle {
    prevent_destroy = false
}

tags = {
  name = "${var.project_name}github-oidc"
}
}

resource "aws_iam_role" "github_actions" {
  name = "${var.project_name}-github-actions-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::555569221122:oidc-provider/token.actions.githubusercontent.com"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:abshirabshir12/${var.github_repo}:*"
          }
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-github-actions"
  }

  lifecycle {
    prevent_destroy = false
  }
}
# checkov:skip=CKV2_AWS_290: ECR wildcard required for CI/CD
resource "aws_iam_role_policy" "github_actions" {
  name = "${var.project_name}-github-actions-policy"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      # ECS – scoped
      {
        Effect = "Allow"
        Action = [
          "ecs:UpdateService",
          "ecs:DescribeServices",
          "ecs:DescribeTaskDefinition"
        ]
        Resource = "arn:aws:ecs:${var.aws_region}:${var.account_id}:service/${var.cluster_name}/*"
      },

      # ECR auth (must be *)
{
  Effect = "Allow"
  Action = [
    "ecr:GetAuthorizationToken"
  ]
  Resource = "*"
},

# ECR repo-specific access
{
  Effect = "Allow"
  Action = [
    "ecr:BatchGetImage",
    "ecr:PutImage"
  ]
  Resource = "arn:aws:ecr:${var.aws_region}:${var.account_id}:repository/*"
},


      # Logs – scoped
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${var.aws_region}:${var.account_id}:log-group:/ecs/*"
      }
    ]
  })
}
