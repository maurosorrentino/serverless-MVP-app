# use the following for lambda from S3
# module "project_name_lambda" {
#   source = "./modules/lambda"

#   project_name     = var.project_name
#   lambda_s3_bucket = data.aws_s3_bucket.lambda_artifacts_s3.bucket
#   layer_key        = "list-s3-contents-${var.lambda_version}-layer.zip"
#   s3_lambda_key    = "list-s3-contents-${var.lambda_version}-lambda.zip"
#   lambda_name      = "${var.project_name}_list_s3_objects"
#   lambda_role_name = local.lambda_role_name
#   lambda_handler   = "get_s3_objects.lambda_handler"
#   lambda_runtime   = "python3.11"
#   region           = var.region
#   account_id       = local.account_id
#   lambda_timeout   = 30
#   lambda_memory    = 128

#   env_vars = {
#     BUCKET_NAME = local.project_name_contents_s3_name
#     LOG_LEVEL   = 20
#   }
# }

# use the following for lambda from ECR
module "project_name_lambda" {
  source = "./modules/lambda"

  lambda_name      = "${var.project_name}_list_s3_objects"
  lambda_image     = var.lambda_image
  lambda_role_name = local.lambda_role_name
  lambda_timeout   = 30
  lambda_memory    = 128
  region           = var.region
  account_id       = local.account_id

  env_vars = {
    BUCKET_NAME = local.project_name_contents_s3_name
    LOG_LEVEL   = 20
  }
}
