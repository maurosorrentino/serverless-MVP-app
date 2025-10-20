resource "aws_kms_key" "project_name_s3_kms_key" {
  description         = "s3 encryption key"
  enable_key_rotation = true

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowRootAndAdminAccess",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            # I'm using root as it's my personal account and often use "terraform destroy"
            # what I would do for a company I would allow a specific role
            "arn:aws:iam::${var.account_id}:root"
            # allow users with a specific role to decrypt logs
            # "arn:aws:iam::${var.account_id}:role/RoleName"
          ]
        },
        # in prod limit the actions to what is strictly necessary
        # I want everything for destroying the stack easily
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
      },
      {
      "Sid": "AllowLambdaUse",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.account_id}:role/${var.lambda_role_name}"
      },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*"
    },
    ]
  })
}

output "kms_arn" {
  value = aws_kms_key.project_name_s3_kms_key.arn
}
