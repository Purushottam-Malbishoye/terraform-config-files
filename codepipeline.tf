resource "aws_codepipeline" "pipeline" {
  name     = "devops-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    type     = "S3"
    location = aws_s3_bucket.artifact_bucket.bucket
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        ConnectionArn     = var.codestar_connection_arn
        FullRepositoryId  = var.github_repo
        BranchName        = var.github_branch
        DetectChanges     = "true"
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      configuration = {
        ProjectName = aws_codebuild_project.build.name
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      name             = "Deploy-App"
      category         = "Deploy"
      owner            = "AWS"
      provider         = "ECS"
      input_artifacts  = ["build_output"]
      configuration = {
        ClusterName = aws_ecs_cluster.devops_cluster.name
        ServiceName = aws_ecs_service.svc.name
        FileName    = "vite-project/imagedefinitions.json"
      }
    }
  }
}

