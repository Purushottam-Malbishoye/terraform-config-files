resource "aws_ecs_service" "svc" {
  name            = "devops-service"
  cluster         = aws_ecs_cluster.devops_cluster.id
  task_definition = aws_ecs_task_definition.devops.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_sg.id]
    subnets          = var.public_subnets
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = "devops-ecr"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.http]
}

