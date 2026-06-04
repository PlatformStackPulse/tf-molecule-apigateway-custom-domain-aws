output "domain_name" {
  description = "The custom domain name"
  value       = module.domain_name.domain_name
}

output "regional_domain_name" {
  description = "Regional domain name for the custom domain"
  value       = module.domain_name.regional_domain_name
}

output "regional_zone_id" {
  description = "Regional zone ID for the custom domain"
  value       = module.domain_name.regional_zone_id
}
