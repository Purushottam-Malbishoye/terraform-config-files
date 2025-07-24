resource "aws_lb" "devops_lb" {
  name               = "devops-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [aws_security_group.ecs_sg.id]
}

resource "aws_lb_target_group" "tg" {
  name     = "devops-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"
  health_check {
    path = "/"
    port = "3000"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.devops_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

