# Unit Tests — tf-molecule-apigateway-custom-domain-aws
#
# These tests use a mock AWS provider — no real AWS calls are made.
# Run with:         terraform test -test-directory=tests/unit
# Run verbose:      terraform test -test-directory=tests/unit -verbose
# Run one:          terraform test -test-directory=tests/unit -run "creates_when_enabled"
#
# Assertions target plan-KNOWN values only (the tf-label id string, resource
# counts, and input pass-throughs). Computed attributes such as the API Gateway
# regional_domain_name / regional_zone_id are unknown under a mock provider and
# are therefore NOT asserted on.

mock_provider "aws" {}

variables {
  # tf-label identity
  namespace = "eg"
  stage     = "test"
  name      = "thing"

  # Module-required inputs (valid-looking sample values)
  domain_name     = "api-test-app.example.com"
  certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
  rest_api_id     = "abc123def4"
  stage_name      = "test"
  zone_id         = "Z0123456789ABCDEFGHIJ"
}

# ---------------------------------------------------------------------------
# Test: module creates its resources when enabled (default)
# ---------------------------------------------------------------------------
run "creates_when_enabled" {
  command = plan

  assert {
    condition     = length(aws_api_gateway_domain_name.this) == 1
    error_message = "Expected exactly one aws_api_gateway_domain_name when enabled"
  }

  assert {
    condition     = length(aws_api_gateway_base_path_mapping.this) == 1
    error_message = "Expected exactly one aws_api_gateway_base_path_mapping when enabled"
  }

  assert {
    condition     = length(aws_route53_record.this) == 1
    error_message = "Expected exactly one aws_route53_record when enabled"
  }

  assert {
    condition     = aws_api_gateway_domain_name.this[0].domain_name == var.domain_name
    error_message = "Domain name should pass through the domain_name input unchanged"
  }

  assert {
    condition     = aws_api_gateway_domain_name.this[0].regional_certificate_arn == var.certificate_arn
    error_message = "Certificate ARN should pass through the certificate_arn input unchanged"
  }

  assert {
    condition     = aws_api_gateway_base_path_mapping.this[0].api_id == var.rest_api_id
    error_message = "Base path mapping should map the provided rest_api_id"
  }

  assert {
    condition     = aws_api_gateway_base_path_mapping.this[0].stage_name == var.stage_name
    error_message = "Base path mapping should map the provided stage_name"
  }

  assert {
    condition     = aws_route53_record.this[0].zone_id == var.zone_id
    error_message = "Route53 record should be created in the provided hosted zone"
  }

  assert {
    condition     = one(aws_api_gateway_domain_name.this[*].endpoint_configuration[0].types[0]) == "REGIONAL"
    error_message = "Endpoint type should default to REGIONAL"
  }
}

# ---------------------------------------------------------------------------
# Test: module creates nothing when disabled
# ---------------------------------------------------------------------------
run "disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = length(aws_api_gateway_domain_name.this) == 0
    error_message = "Expected no aws_api_gateway_domain_name when disabled"
  }

  assert {
    condition     = length(aws_api_gateway_base_path_mapping.this) == 0
    error_message = "Expected no aws_api_gateway_base_path_mapping when disabled"
  }

  assert {
    condition     = length(aws_route53_record.this) == 0
    error_message = "Expected no aws_route53_record when disabled"
  }

  assert {
    condition     = output.domain_name == ""
    error_message = "domain_name output should be empty when disabled"
  }
}
