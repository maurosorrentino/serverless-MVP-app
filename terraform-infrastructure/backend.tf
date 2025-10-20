terraform {
  backend "s3" {
    # TODO REMOVE THIS AND USE ENV VARIABLES
    # bucket, key, dynamo table and region is in the terraform init command and 
    # env variable are in .github/workflows/ENV/dev or prod/env_vars.json
    encrypt        = true
    bucket         = "terraform-state-department-name"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-lock-table"
  }
}
