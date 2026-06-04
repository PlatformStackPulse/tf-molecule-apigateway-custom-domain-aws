variable "domain_name" {
  description = "Custom domain name (e.g., api-dev-app.xpeeddating.com)"
  type        = string
}

variable "certificate_arn" {
  description = "ACM certificate ARN for the domain"
  type        = string
}

variable "rest_api_id" {
  description = "ID of the REST API to map"
  type        = string
}

variable "stage_name" {
  description = "Stage name to map (e.g., 'dev')"
  type        = string
}

variable "zone_id" {
  description = "Route53 hosted zone ID"
  type        = string
}

variable "endpoint_type" {
  description = "Endpoint type (REGIONAL or EDGE)"
  type        = string
  default     = "REGIONAL"
}
