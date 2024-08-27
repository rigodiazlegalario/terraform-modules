resource "aws_lb_target_group" "tg_legalario" {
  name        = "tg-${var.project_name}-${var.env}"
  port        = var.tg_port
  vpc_id      = var.vpc_id
  target_type = "ip"
  protocol    = "HTTP"
  health_check {
    path = var.health_check_path
  }
}

data "aws_lb" "alb_legalario" {
  name = var.elb_name
}

resource "aws_route53_record" "legalario_fairplay_record" {
  zone_id = var.zone_id
  name    = var.dns_name
  type    = "A"

  alias {
    name                   = data.aws_lb.alb_legalario.dns_name
    zone_id                = data.aws_lb.alb_legalario.zone_id
    evaluate_target_health = true
  }
}

data "aws_lb_listener" "listener" {
  load_balancer_arn = data.aws_lb.alb_legalario.arn
  port              = 443
}

resource "aws_lb_listener_rule" "listener_rule" {
  listener_arn = data.aws_lb_listener.listener.arn
  priority     = var.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_legalario.arn
  }

  condition {
    host_header {
      values = ["${var.dns_name}.${var.domain}"]
    }
  }
}
