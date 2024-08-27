variable "project_name" {
  description = "value for the main name of the resources"
  type        = string
}

variable "environment" {
  type = string
}

variable "env" {
  type = string
}

variable "cluster_name" {
  description = "cluster name"
  type        = string
}

variable "cluster_count" {
  description = "bool variable to create cluster"
  type        = bool
}

variable "cluster_container_insights" {
  description = "enable or disable expected"
  type        = string
}

variable "task_definition" {
  description = "task definition variables"
  type = object({
    family                  = string
    cpu                     = number
    memory                  = number
    task_execution_role_arn = string
    task_role_arn           = string
  })
}

variable "ecs_containers" {
  description = "container definitions values"
  type = list(object({
    name   = string
    image  = string
    cpu    = number
    memory = number
    portMappings = list(object({
      containerPort = number
      hostPort      = number
    }))
    secrets = optional(list(object({
      name      = string
      valueFrom = string
    })))
    environmentFiles = optional(list(object({
      value = string
      type  = string
    })))
    healthCheck = optional(object({
      command     = list(string)
      interval    = number
      timeout     = number
      retries     = number
      startPeriod = number
    }))
    dependsOn = optional(list(object({
      containerName = string
      condition     = string
    })))
    logConfiguration = object({
      logDriver = string
      options   = map(string)
    })
  }))
}

variable "desired_count" {
  description = "number of task for the ecs service"
  type        = number
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "security_group" {
  type = string
}

variable "container_port" {
  type = number
}

variable "container_name" {
  type = string
}

variable "target_group_arn" {
  type = string
}
