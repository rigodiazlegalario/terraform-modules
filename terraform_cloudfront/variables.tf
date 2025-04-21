variable "environment_name" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "bucket_name_website" {
  description = "S3 bucket name (no ARN, just the name)"
  type        = string
}

variable "alias_domain" {
  description = "CloudFront alias domain"
  type        = string
}

variable "waf_web_acl_arn" {
  description = "WAFv2 ARN (for WebACLId)"
  type        = string
}

variable "bucket_domain_name" {
  description = "Domain name of the S3 bucket"
  type        = string
}

variable "logging_bucket_name" {
  description = "Nombre del bucket para logs"
  type        = string
  default     = "esignature-logs-web-v1"
}
