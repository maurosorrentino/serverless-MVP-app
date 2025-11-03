resource "aws_iam_policy" "project_name_lambda_policy" {
  name = "${var.project_name}-lambda-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "s3:ListBucket"
        Resource = [
          module.project_name_s3.bucket_arn,
          "${module.project_name_s3.bucket_arn}/*"
        ]
      },
      # comment the following if using lambda from S3
      {
        Effect = "Allow"
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ]
        Resource = "arn:aws:ecr:${var.region}:${data.aws_caller_identity.current.account_id}:repository/${var.project_name}-ecr-lambda-repo"
      }
    ]
  })

  depends_on = [module.project_name_s3]
}

resource "aws_iam_role_policy_attachment" "attach_custom" {
  role       = local.lambda_role_name
  policy_arn = aws_iam_policy.project_name_lambda_policy.arn

  depends_on = [module.project_name_lambda]
}
