resource "aws_apigatewayv2_api" "project_name_api" {
  name          = var.api_name
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"] # this should be changed to specific domains
    allow_methods = ["GET"]
  }
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.project_name_api.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  integration_uri        = var.lambda_invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "get_list" {
  api_id    = aws_apigatewayv2_api.project_name_api.id
  route_key = "GET /list"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "prod" {
  api_id      = aws_apigatewayv2_api.project_name_api.id
  name        = "$default"
  auto_deploy = true
}
