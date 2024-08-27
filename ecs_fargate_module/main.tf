resource "aws_ecs_cluster" "ecs_cluster_legalario" {
  count = var.cluster_count ? 1 : 0

  name = var.cluster_name
  setting {
    name  = "containerInsights"
    value = var.cluster_container_insights
  }
}

resource "aws_ecs_task_definition" "task_definition_legalario" {
  family = var.task_definition.family

  execution_role_arn = var.task_definition.task_execution_role_arn
  task_role_arn      = var.task_definition.task_role_arn

  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_definition.cpu
  memory                   = var.task_definition.memory
  container_definitions = jsonencode(
    var.ecs_containers
  )
}

resource "aws_ecs_service" "ecs_service_legalario" {
  name            = "${var.project_name}-service"
  cluster         = var.cluster_count ? aws_ecs_cluster.ecs_cluster_legalario[0].id : var.cluster_name
  task_definition = aws_ecs_task_definition.task_definition_legalario.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  network_configuration {
    assign_public_ip = false
    subnets          = var.private_subnets
    security_groups  = [var.security_group]
  }
}