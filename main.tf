# Molecule: API Gateway Custom Domain (Domain Name + Base Path Mapping + Route53 Record)

resource "aws_api_gateway_domain_name" "this" {
  count = module.this.enabled ? 1 : 0

  domain_name              = var.domain_name
  regional_certificate_arn = var.certificate_arn

  endpoint_configuration {
    types = [var.endpoint_type]
  }

  tags = module.this.tags
}

resource "aws_api_gateway_base_path_mapping" "this" {
  count = module.this.enabled ? 1 : 0

  api_id      = var.rest_api_id
  stage_name  = var.stage_name
  domain_name = aws_api_gateway_domain_name.this[0].domain_name
}

resource "aws_route53_record" "this" {
  count = module.this.enabled ? 1 : 0

  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.this[0].regional_domain_name
    zone_id                = aws_api_gateway_domain_name.this[0].regional_zone_id
    evaluate_target_health = true
  }
}
