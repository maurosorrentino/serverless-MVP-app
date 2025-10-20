locals {
  project_name_contents_s3_name = "${var.project_name}-testttt-imperatives-s3"
  github_actions_role_name      = "devGitHubActionsProjectNameRole"
  lambda_role_name              = "${var.project_name}NameLambdaRole"
  api_name = "${var.project_name}-api-gateway"
}
