variable "aws_region" {
  default = "ap-south-1"
}

variable "aws_account_id" {}

variable "ecr_repo_name" {
  default = "devops-ecr"
}

variable "github_repo" {
  description = "Format: username/repo"
}

variable "github_branch" {
  default = "main"
}

variable "codestar_connection_arn" {
  description = "ARN of manually approved GitHub CodeStar connection"
}

