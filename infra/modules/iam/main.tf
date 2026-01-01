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
        Resource = "*"
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

resource "aws_iam_role_policy" "github_actions" {
  name = "${var.project_name}-github-actions-policy"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:*",
          "ecs:*",
          "ecr:*",
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:GetRole",
          "iam:ListRolePolicies",
          "iam:GetRolePolicy",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:ListAttachedRolePolicies",
          "iam:ListInstanceProfilesForRole",
          "iam:RemoveRoleFromInstanceProfile",
          "iam:ListInstanceProfiles",
          "iam:CreateOpenIDConnectProvider",
          "iam:DeleteOpenIDConnectProvider",
          "iam:GetOpenIDConnectProvider",
          "iam:TagOpenIDConnectProvider",
          "iam:TagRole",
          "iam:UntagRole",
          "iam:PassRole",
          "logs:*",
          "acm:DescribeCertificate",
          "route53:ChangeResourceRecordSets",
          "route53:GetChange",
          "route53:GetHostedZone",
          "route53:ListHostedZones",
          "route53:ListHostedZonesByName",
          "route53:ListResourceRecordSets",
          "elasticloadbalancing:*",
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:HeadBucket",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:DescribeTable",
          "dynamodb:UpdateItem"
        ]
        Resource = "*"
      }
    ]
  })
}