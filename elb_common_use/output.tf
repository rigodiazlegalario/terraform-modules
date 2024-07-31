output "target_group_arn" {
  value = aws_lb_target_group.tg_legalario.arn
}

output "alb_dns" {
  value = data.aws_lb.alb_legalario.dns_name
}

output "alb_zone" {
  value = data.aws_lb.alb_legalario.zone_id
}
