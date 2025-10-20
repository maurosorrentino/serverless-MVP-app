resource "aws_apigatewayv2_api" "http_api" {
  name          = var.api_name
  protocol_type = "HTTP"                            
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.http_api.id       
  integration_type       = "AWS_PROXY"                            # Lambda proxy integration
  integration_uri        = var.lambda_invoke_arn         
  payload_format_version = "2.0"                                  # Modern payload version
}

resource "aws_apigatewayv2_route" "route" {
  api_id              = aws_apigatewayv2_api.http_api.id
  route_key           = "GET /"                                   # Single GET / route
  target              = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
  authorization_type  = "AWS_IAM"                                 
}

# Stage with access logging
resource "aws_apigatewayv2_stage" "access_logging_stage" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "access_logging_stage"
  auto_deploy = true                                               # Automatically deploy changes

  access_log_settings {
    destination_arn = var.log_group_arn
    format          = jsonencode({
      requestId = "$context.requestId"
      ip        = "$context.identity.sourceIp"
      caller    = "$context.identity.caller"
      user      = "$context.identity.user"
      status    = "$context.status"
      latency   = "$context.responseLatency"
    })
  }
}

resource "aws_lambda_permission" "apigw_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"                         
  action        = "lambda:InvokeFunction"                         
  function_name = var.lambda_function_name                        
  principal     = "apigateway.amazonaws.com"                      
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

resource "aws_iam_policy" "invoke_policy" {
  name        = var.policy_name
  description = "Allow only specific principal to invoke API Gateway"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["execute-api:Invoke"]
        Resource = "${aws_apigatewayv2_api.http_api.execution_arn}/*/GET/"
        Condition = {
          StringEquals = {
            "aws:PrincipalArn" = [
              "arn:aws:iam::${var.account_id}:root",
              "arn:aws:iam::${var.account_id}:role/${var.github_actions_role_name}"
            ]
          }
        }
      }
    ]
  })
}

resource "aws_cloudwatch_log_resource_policy" "api_gw_log_policy" {
  policy_name     = "ApiGatewayPushToCloudWatch"
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "apigateway.amazonaws.com" }
      Action = "logs:PutLogEvents"
      Resource = var.log_group_arn
    }]
  })
}
