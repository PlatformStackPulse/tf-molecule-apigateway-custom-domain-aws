# Molecule: API Gateway Custom Domain with Route53 DNS (REST API v1)

module "domain_name" {
  source = "git::https://github.com/PlatformStackPulse/tf-atom-apigateway-domain-name-aws.git?ref=2f2337934bc3ec9b623774a0112cc033a3ae0dd5"

  context                  = module.this.context
  domain_name              = var.domain_name
  regional_certificate_arn = var.certificate_arn
  endpoint_type            = var.endpoint_type
}

module "base_path_mapping" {
  source = "git::https://github.com/PlatformStackPulse/tf-atom-apigateway-base-path-mapping-aws.git?ref=5a977cadc610936b62ecdc5651babfb0f1f61de1"

  context     = module.this.context
  domain_name = module.domain_name.domain_name
  rest_api_id = var.rest_api_id
  stage_name  = var.stage_name

  depends_on = [module.domain_name]
}

module "dns_record" {
  source = "git::https://github.com/PlatformStackPulse/tf-atom-route53-record-aws.git?ref=e83e2ca88dc9d9681a321785b6cf623d81cca814"

  context = module.this.context
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"

  alias = {
    name                   = module.domain_name.regional_domain_name
    zone_id                = module.domain_name.regional_zone_id
    evaluate_target_health = true
  }

  depends_on = [module.domain_name]
}
