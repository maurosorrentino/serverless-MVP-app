resource "aws_iam_role" "project_name_lambda_exec" {
  name = var.lambda_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "project_name_lambda_policy" {
  name = "${var.lambda_name}LambdaPushToCloudWatch"
  policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          Resource = "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/lambda/${var.lambda_name}:*"
        }
      ]
    })
}

resource "aws_iam_role_policy_attachment" "project_name_lambda_basic" {
  role       = aws_iam_role.project_name_lambda_exec.name
  policy_arn = aws_iam_policy.project_name_lambda_policy.arn
}

output "lambda_role_name" {
  value = aws_iam_role.project_name_lambda_exec.name
}
