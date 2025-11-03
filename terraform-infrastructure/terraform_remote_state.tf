data "terraform_remote_state" "terraform_bootstrap" {
  backend = "s3"
  config = {
    bucket         = "terraform-state-department-name-serverless-project"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
  }
}
