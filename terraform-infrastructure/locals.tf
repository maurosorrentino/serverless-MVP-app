locals {
  project_name_contents_s3_name = "${var.project_name}-contents-${var.region}-imperatives-s3"
  github_actions_role_name      = "${var.environment}GitHubActionsProjectNameRole"
  lambda_role_name              = "${var.project_name}NameLambdaRole"
  api_name                      = "${var.project_name}-api-gateway"
  account_id                    = data.aws_caller_identity.current.account_id
}
