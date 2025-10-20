resource "aws_lambda_layer_version" "project_name_dependencies_layer" {
  layer_name          = "${var.project_name}_dependencies"
  compatible_runtimes = [var.lambda_runtime]

  s3_bucket = var.lambda_s3_bucket
  s3_key    = var.layer_key
}


resource "aws_lambda_function" "project_name_list_s3_objects_lambda" {
  function_name    = var.lambda_name
  role             = aws_iam_role.project_name_lambda_exec.arn
  s3_bucket        = var.lambda_s3_bucket
  s3_key    = var.s3_lambda_key
  handler          = var.lambda_handler
  runtime          = var.lambda_runtime
  timeout          = var.lambda_timeout
  memory_size      = var.lambda_memory
  layers           = [aws_lambda_layer_version.project_name_dependencies_layer.arn]

  environment {
    variables = var.env_vars
  }
}

resource "aws_lambda_function_event_invoke_config" "project_name_lambda_invoke_config" {
  function_name = aws_lambda_function.project_name_list_s3_objects_lambda.function_name

  maximum_retry_attempts = 2
}

output "lambda_invoke_arn" {
  value = aws_lambda_function.project_name_list_s3_objects_lambda.invoke_arn
}

output "lambda_arn" {
  value = aws_lambda_function.project_name_list_s3_objects_lambda.arn
}
