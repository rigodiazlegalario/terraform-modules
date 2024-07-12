output "ecs_cluster_id" {
  description = "The ID of the ECS cluster."
  value       = aws_ecs_cluster.ecs_cluster_legalario.id
}

output "ecs_task_definition_arn" {
  description = "The ARN of the ECS task definition."
  value       = aws_ecs_task_definition.task_definition_legalario.arn
}

output "ecs_service_name" {
  description = "The name of the ECS service."
  value       = aws_ecs_service.ecs_service_legalario.name
}