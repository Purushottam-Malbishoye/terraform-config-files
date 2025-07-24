output "alb_dns" {
  value = aws_lb.devops_lb.dns_name
}

output "ecr_repo_url" {
  value = aws_ecr_repository.repo.repository_url
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.devops_cluster.id
}

