terraform {
  backend "s3" {
    # bucket, key, dynamo table and region is in the terraform init command and 
    # env variable are in pipeline
    encrypt        = true
  }
}
