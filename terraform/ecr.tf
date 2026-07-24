#############################################
# Amazon Elastic Container Registry (ECR)
#############################################

resource "aws_ecr_repository" "main" {

  name                 = local.ecr_repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = merge(
    local.common_tags,
    {
      Name = local.ecr_repository_name
    }
  )
}

#############################################
# Lifecycle Policy
#############################################

resource "aws_ecr_lifecycle_policy" "main" {

  repository = aws_ecr_repository.main.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 20 images"

        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 20
        }

        action = {
          type = "expire"
        }
      }
    ]
  })
}

#############################################
# Repository Policy
#############################################

data "aws_iam_policy_document" "ecr_repository" {

  statement {

    sid    = "AllowAccountAccess"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:DescribeRepositories",
      "ecr:DescribeImages",
      "ecr:ListImages"
    ]
  }
}

resource "aws_ecr_repository_policy" "main" {

  repository = aws_ecr_repository.main.name
  policy     = data.aws_iam_policy_document.ecr_repository.json
}

