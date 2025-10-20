module "project_name_lambda" {
  source = "./modules/lambda"

  lambda_role_name = local.lambda_role_name
  project_name     = var.project_name
  lambda_s3_bucket_id = data.aws_s3_bucket.lambda_artifacts_s3.id
  filename       = "s3://${data.aws_s3_bucket.lambda_artifacts_s3.bucket}/list-s3-contents-${var.lambda_version}-lambda.zip"
  s3_key          = "list-s3-contents-${var.lambda_version}-lambda.zip" 
  lambda_name      = "${var.project_name}_list_s3_objects"
  lambda_handler   = "get_s3_objects.lambda_handler"
  lambda_runtime   = "python3.11"
  lambda_timeout   = 30
  lambda_memory    = 128

  env_vars = {
    BUCKET_NAME = local.project_name_contents_s3_name
    LOG_LEVEL   = 20
  }
}

# resource "aws_lambda_permission" "allow_apigw" {
#   statement_id  = "AllowAPIGatewayInvoke"
#   action        = "lambda:InvokeFunction"
#   function_name = module.project_name_lambda.lambda_arn
#   principal     = "apigateway.amazonaws.com"
#   source_arn    = "${aws_apigatewayv2_api.project_name_api.execution_arn}/*/*" # TODO
# }
