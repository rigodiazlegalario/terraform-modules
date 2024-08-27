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

variable "public_subnets" {
  type = list(string)
}

variable "elb_security_group" {
  type = string
}

variable "zone_id" {
  type = string
}

variable "dns_name" {
  type = string
}

variable "certificate_arn" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "tg_port" {
  type = number
}

variable "health_check_path" {
  type = string
}