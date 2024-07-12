resource "aws_lb" "alb_legalario" {
  name               = "alb-${var.project_name}-${var.env}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.elb_security_group]
  subnets            = var.public_subnets
}

resource "aws_lb_target_group" "tg_legalario" {
  name        = "tg-${var.project_name}-${var.env}"
  port        = var.tg_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    path = var.health_check_path
  }
}

resource "aws_lb_listener" "lb_listener_https" {
  load_balancer_arn = aws_lb.alb_legalario.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_legalario.arn
  }
}

resource "aws_lb_listener" "aws_lb_listener_http" {
  load_balancer_arn = aws_lb.alb_legalario.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
