resource "aws_codestarconnections_connection" "github" {
  name          = "devops-connection"
  provider_type = "GitHub"
}

output "codestar_connection_id" {
  value = aws_codestarconnections_connection.github.arn
}

