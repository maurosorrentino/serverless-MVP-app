resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = module.project_name_s3.bucket_id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowLambdaAccess"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.lambda_role_name}"
        }
        Action = "s3:ListBucket"
        Resource = [
          "arn:aws:s3:::${local.project_name_contents_s3_name}",
          "arn:aws:s3:::${local.project_name_contents_s3_name}/*"
        ]
      },
      {
        Sid       = "DenyAllOthers"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          "arn:aws:s3:::${local.project_name_contents_s3_name}",
          "arn:aws:s3:::${local.project_name_contents_s3_name}/*"
        ]
        Condition = {
          StringNotEquals = {
            # deny access to everyone except root user (or a role for a production setup)
            "aws:PrincipalArn" = [
              "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
              "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.github_actions_role_name}"
            ]
          }
        }
      }
    ]
  })

  depends_on = [module.project_name_s3]
}
