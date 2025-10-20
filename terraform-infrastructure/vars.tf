variable "region" {
  description = "aws region where to deploy resources"
  type        = string
}

variable "project_name" {
  type    = string
  default = "project-name"
}

variable "lambda_version" {
  type = string
}

variable "s3_lambda_name" {
  description = "The S3 bucket where Lambda artifacts are stored"
  type        = string
}
