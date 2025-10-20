module "project_name_s3_kms" {
  source = "./modules/s3_kms"

  account_id       = data.aws_caller_identity.current.id
  bucket_name      = local.project_name_contents_s3_name
  github_actions_role_name = local.github_actions_role_name

  depends_on = [module.project_name_lambda]
}
