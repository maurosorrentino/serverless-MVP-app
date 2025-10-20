module "project_name_api_gateway" {
  source = "./modules/api_gateway"
  
  api_name = "${var.project_name}-api-gateway"
  lambda_invoke_arn = module.project_name_lambda.lambda_arn
  policy_name = "${var.project_name}-api-gateway-policy"
  github_actions_role_name = local.github_actions_role_name
  log_group_arn = aws_cloudwatch_log_group.project_name_log_group.arn
  account_id = data.aws_caller_identity.current.account_id
  lambda_function_name = module.project_name_lambda.lambda_name
}
