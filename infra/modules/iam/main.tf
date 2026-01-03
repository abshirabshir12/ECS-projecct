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

# checkov:skip=CKV_AWS_355: GitHub Actions requires wildcard permissions for ECS/ECR/IAM orchestration
resource "aws_iam_role_policy" "github_actions" {
  name = "${var.project_name}-github-actions-policy"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
# --- ECS read-only (allowed to use *) ---
{
  Effect = "Allow"
  Action = [
    "ecs:DescribeServices",
    "ecs:DescribeTaskDefinition"
  ]
  Resource = "*"
},

# --- ECS write (MUST be scoped) ---
{
  Effect = "Allow"
  Action = [
    "ecs:UpdateService",
    "ecs:RegisterTaskDefinition"
  ]
  Resource = "arn:aws:ecs:${var.aws_region}:${var.account_id}:service/${var.cluster_name}/*"
},


      {
        Effect = "Allow"
        Action = "ecr:GetAuthorizationToken"
        Resource = "*"
      },

      # --- ECR: push images (scoped) ---
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage",
          "ecr:BatchGetImage"
        ]
        Resource = "arn:aws:ecr:${var.aws_region}:${var.account_id}:repository/${var.project_name}*"
      },

      # --- Pass ONLY the ECS task execution role ---
      {
        Effect = "Allow"
        Action = "iam:PassRole"
        Resource = "arn:aws:iam::${var.account_id}:role/${var.project_name}-ecs-task-execution-role"
      }
    ]
  })
}
