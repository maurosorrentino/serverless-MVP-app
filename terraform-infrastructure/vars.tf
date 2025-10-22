variable "project_name" {
  type    = string
}

variable "lambda_version" {
  type = string
}

# some company use ENV in naming conventions
variable "ENV" {
  type = string
}

# using it in names might be usefull to have unique names (s3 for example)
variable "AWS_REGION" {
  description = "aws region where to deploy resources"
  type        = string
}
