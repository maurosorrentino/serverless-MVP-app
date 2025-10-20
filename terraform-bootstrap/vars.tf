variable "env" {
  description = "The deployment environment (dev, prod)"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "eu-west-2"
}

variable "github_thumbprint" {
  description = "The GitHub OIDC thumbprint"
  type        = string
  default     = "6938fd4d98bab03faadb97b34396831e3780aea1"
}

variable "github_repo" {
  description = "The GitHub repository in the format owner/repo"
  type        = string
}
