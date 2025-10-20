resource "aws_s3_bucket" "terraform_state" {
    bucket = "terraform-state-department-name-testtt"
}

resource "aws_s3_bucket" "lambda_artifacts" {
    bucket = "list-s3-contents-lambda-code-s3"
}
