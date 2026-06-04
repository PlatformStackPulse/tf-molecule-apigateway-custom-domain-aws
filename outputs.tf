output "domain_name" {
  description = "The custom domain name"
  value       = try(aws_api_gateway_domain_name.this[0].domain_name, "")
}

output "regional_domain_name" {
  description = "Regional domain name for the custom domain"
  value       = try(aws_api_gateway_domain_name.this[0].regional_domain_name, "")
}

output "regional_zone_id" {
  description = "Regional zone ID for the custom domain"
  value       = try(aws_api_gateway_domain_name.this[0].regional_zone_id, "")
}
