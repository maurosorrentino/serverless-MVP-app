variable "region" {
  description = "aws region where to deploy resources"
  type        = string
  default     = "eu-west-2"
}

variable "project_name" {
  type    = string
  default = "project-name"
}

variable "environment" {
  type = string
  default = "dev"
}

# use this for lambda from ECR
variable "lambda_image" {
  type = string
}

# # use this for lambda from S3
# variable "lambda_version" {
#   type = string
# }
