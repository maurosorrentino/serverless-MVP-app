data "aws_s3_bucket" "lambda_artifacts_s3" {
  bucket = "list-s3-contents-lambda-code-s3"
}

module "project_name_s3" {
  source = "./modules/s3"

  bucket_name = local.project_name_contents_s3_name
  kms_key_arn = module.project_name_s3_kms.kms_arn

  depends_on = [module.project_name_s3_kms]
}
