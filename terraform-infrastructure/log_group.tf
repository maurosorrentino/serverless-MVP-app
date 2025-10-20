resource "aws_cloudwatch_log_group" "project_name_api_gtw_log_group" {
  name              = "/aws/apigateway/${local.api_name}"
  retention_in_days = 14
}
