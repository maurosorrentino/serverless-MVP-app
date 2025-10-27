variable "account_id" {
  description = "The AWS account ID that will own the KMS key and has full access to it"
  type        = string
}

variable "bucket_name" {
  description = "bucket name for kms key"
  type        = string
}

variable "github_actions_role_name" {
  description = "IAM role name that the GitHub Actions workflow will use"
  type        = string
}
