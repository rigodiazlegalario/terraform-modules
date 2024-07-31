variable "project_name" {
  type = string
}

variable "env" {
  type = string
  description = "environment abbreviation"
}

variable "tg_port" {
  type = number
}

variable "health_check_path" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "elb_name" {
  type = string
}

variable "zone_id" {
  type = string
  description = "zone id of the route 53 hosted zone"
}

variable "dns_name" {
  type = string
}

variable "priority" {
  type = number
}

variable "domain" {
  type = string
  default = "legalario.com"
}