resource "aws_s3_bucket" "project_name_s3" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_server_side_encryption_configuration" "project_name_s3_sse" {
  bucket = aws_s3_bucket.project_name_s3.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

output "bucket_id" {
  value = aws_s3_bucket.project_name_s3.id
}

output "bucket_arn" {
  value = aws_s3_bucket.project_name_s3.arn
}
