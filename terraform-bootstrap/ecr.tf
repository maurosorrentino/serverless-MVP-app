resource "aws_ecr_repository" "project_name_ecr_repo" {
  name                 = "${var.project_name}-ecr-lambda-repo"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "project_name_ecr_lc_policy" {
  repository = aws_ecr_repository.project_name_ecr_repo.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images if more than 4 exist"
        selection = {
          tagStatus = "tagged"
          tagPrefixList : ["v"]
          countType   = "imageCountMoreThan"
          countNumber = 4
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

resource "aws_ecr_repository_policy" "lambda_pull" {
  repository = aws_ecr_repository.project_name_ecr_repo.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "LambdaECRImageRetrievalPolicy"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = [
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer"
        ]
      }
    ]
  })
}
