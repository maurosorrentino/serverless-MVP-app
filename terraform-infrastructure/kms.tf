module "project_name_s3_kms" {
  source = "./modules/s3_kms"

  account_id       = data.aws_caller_identity.current.id
  bucket_name      = local.project_name_bucket_name
  lambda_role_name = local.lambda_role_name

  depends_on = [module.project_name_lambda]
}
