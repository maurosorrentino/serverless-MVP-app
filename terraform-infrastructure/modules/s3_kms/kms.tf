resource "aws_kms_key" "project_name_s3_kms_key" {
  description         = "s3 encryption key"
  enable_key_rotation = true

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowRole",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${var.account_id}:role/${var.github_actions_role_name}"
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
      {
        "Sid" : "AllowS3Use",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "s3.amazonaws.com"
        },
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ],
        "Resource" : "*",
        "Condition" : {
          "StringEquals": {
            "aws:SourceArn": "arn:aws:s3:::${var.bucket_name}"
          }
        }
      }
    ]
  })
}

output "kms_arn" {
  value = aws_kms_key.project_name_s3_kms_key.arn
}
