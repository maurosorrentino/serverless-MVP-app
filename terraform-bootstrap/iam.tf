resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [var.github_thumbprint]
}

resource "aws_iam_role" "github_actions_role" {
  name = "${var.env}GitHubActionsProjectNameRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.github.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringLike = {
          "token.actions.githubusercontent.com:sub" = [
            "repo:${var.github_repo}:ref:refs/tags/v*",
            "repo:${var.github_repo}:environment:*"
          ]
        }
      }
    }]
  })
}

resource "aws_iam_policy" "github_actions_policy" {
  name        = "${var.env}GitHubActionsProjectNamePolicy"
  description = "Policy for GitHub Actions to deploy S3, Lambda, API Gateway, and IAM resources"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "TerraformDeploymentPermissions",
        Effect = "Allow",
        Action = [
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:GetRole",
          "iam:PutRolePolicy",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:PassRole",
          "lambda:CreateFunction",
          "lambda:DeleteFunction",
          "lambda:GetFunction",
          "lambda:UpdateFunctionCode",
          "lambda:UpdateFunctionConfiguration",
          "lambda:AddPermission",
          "lambda:RemovePermission",
          "apigateway:*",
          "s3:CreateBucket",
          "s3:DeleteBucket",
          "s3:ListAllMyBuckets",
          "s3:GetBucketLocation",
          "s3:PutBucketPolicy",
          "s3:GetBucketPolicy",
          "s3:DeleteBucketPolicy",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "cloudwatch:*",
          "sts:GetCallerIdentity",
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan",
          "dynamodb:UpdateItem",
          "iam:TagRole",
          "lambda:PublishLayerVersion",
          "iam:ListRolePolicies",
          "s3:GetObject",
          "lambda:GetLayerVersion",
          "lambda:DeleteLayerVersion",
          "iam:ListAttachedRolePolicies"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_github_policy" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.github_actions_policy.arn
}
