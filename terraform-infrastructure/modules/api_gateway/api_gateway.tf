resource "aws_apigatewayv2_api" "http_api" {
  name          = var.api_name
  protocol_type = "HTTP"                            
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.http_api.id       
  integration_type       = "AWS_PROXY" # lambda handles req / res
  integration_uri        = var.lambda_invoke_arn         
  payload_format_version = "2.0" # latest
}

resource "aws_apigatewayv2_route" "route" {
  api_id              = aws_apigatewayv2_api.http_api.id
  route_key           = "GET /" # Single GET / route
  target              = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
  authorization_type  = "AWS_IAM"                                 
}

resource "aws_apigatewayv2_stage" "stage_name" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = var.environment
  auto_deploy = true # avoid creating aws_apigatewayv2_deployment resource

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
