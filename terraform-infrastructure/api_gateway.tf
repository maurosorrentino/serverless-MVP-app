module "project_name_api_gateway" {
  source = "./modules/api_gateway"

  api_name                    = local.api_name
  lambda_invoke_arn           = module.project_name_lambda.lambda_arn
  environment                 = var.environment
  policy_name                 = "${var.project_name}-api-gateway-policy"
  role_name_allowed_to_invoke = local.github_actions_role_name
  log_group_arn               = aws_cloudwatch_log_group.project_name_api_gtw_log_group.arn
  account_id                  = data.aws_caller_identity.current.account_id
  lambda_function_name        = module.project_name_lambda.lambda_name

  depends_on = [module.project_name_lambda, aws_cloudwatch_log_group.project_name_api_gtw_log_group]
}
