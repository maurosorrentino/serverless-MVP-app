resource "aws_lambda_permission" "apigw_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"

  depends_on = [aws_apigatewayv2_api.http_api]
}

resource "aws_iam_policy" "invoke_policy" {
  name        = var.policy_name
  description = "Allow only specific principal to invoke API Gateway"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["execute-api:Invoke"]
        Resource = "${aws_apigatewayv2_api.http_api.execution_arn}/${var.environment}/GET/"
        Condition = {
          StringEquals = {
            "aws:PrincipalArn" = [
              "arn:aws:iam::${var.account_id}:root",
              # this is used as an example of another principal that might need access, change as needed
              "arn:aws:iam::${var.account_id}:role/${var.role_name_allowed_to_invoke}"
            ]
          }
        }
      }
    ]
  })

  depends_on = [aws_apigatewayv2_api.http_api]
}

resource "aws_cloudwatch_log_resource_policy" "api_gw_log_policy" {
  policy_name = "ApiGatewayPushToCloudWatch"
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "apigateway.amazonaws.com" }
      Action    = [
        "logs:PutLogEvents",
        "logs:CreateLogStream"
      ]
      Resource  = "${var.log_group_arn}:*"
    }]
  })
}
