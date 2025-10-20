variable "lambda_role_name" {
  type = string
}

variable "lambda_name" {
  type = string
}

variable "lambda_handler" {
  description = "the function entry point in the code"
  type = string
}

variable "lambda_runtime" {
  description = "the runtime environment for the Lambda function"
  type = string
}

variable "lambda_timeout" {
  description = "the amount of time that Lambda allows a function to run before stopping it"
  type        = number
}

variable "lambda_memory" {
  type        = number
}

variable "env_vars" {
  description = "environment variables for the lambda function"
  type        = map(string)
  default     = {}
}

variable "project_name" {
  type = string
}

variable "lambda_s3_bucket_id" {
  description = "The S3 bucket where Lambda artifacts are stored"
  type        = string
}

variable "s3_key" {
  description = "The S3 key for the Lambda function code"
  type        = string
}
