module "project_name_s3" {
  source = "./modules/s3"

  bucket_name = local.project_name_bucket_name
  kms_key_arn = module.project_name_s3_kms.kms_arn

  depends_on = [module.project_name_s3_kms]
}
