data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com", "codebuild.amazonaws.com", "codepipeline.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codebuild_role" {
  name               = "codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role" "codepipeline_role" {
  name               = "codepipeline-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy_attachment" "codepipeline_policy" {
  name       = "codepipeline-attach"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipelineFullAccess"
  roles      = [aws_iam_role.codepipeline_role.name]
}

resource "aws_iam_policy_attachment" "codebuild_policy" {
  name       = "codebuild-attach"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess"
  roles      = [aws_iam_role.codebuild_role.name]
}

resource "aws_iam_policy_attachment" "ecs_task_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  roles      = [aws_iam_role.ecs_task_execution_role.name]
}

resource "aws_iam_policy" "codepipeline_codebuild_policy" {
  name        = "codepipeline-codebuild-policy"
  description = "Allow CodePipeline to interact with CodeBuild"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "codebuild:StartBuild",
          "codebuild:BatchGetBuilds",
          "codebuild:BatchGetProjects",
          "codebuild:ListBuilds",
          "codebuild:ListBuildsForProject"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "codepipeline_codebuild_attach" {
  name       = "codepipeline-codebuild-attach"
  policy_arn = aws_iam_policy.codepipeline_codebuild_policy.arn
  roles      = [aws_iam_role.codepipeline_role.name]
}

resource "aws_iam_policy" "codebuild_logstream_policy" {
  name        = "codebuild-logstream-policy"
  description = "Allow CodeBuild to create log streams"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream"
        ],
        Resource = [
          "*"
        ]
      }
    ]
  })
}

