module "api-gateway-backend-api" {
  source = "./modules/api-gateway"

  environment = var.environment

  api_gateway_rest_api_name = "${var.project_prefix}-${var.environment}-api-gw"

  api_gateway_rest_api_tags = {
    Name = "${var.project_prefix}-${var.environment}-api-gw"
    Project = var.project_prefix
    Environment = "${var.project_prefix}-${var.environment}"
  }

  uri = module.backend-api.invoke_arn

  api_gateway_api_key_name = "${var.project_prefix}-${var.environment}-api-gw-key"

  api_gateway_api_key_tags = {
    Name = "${var.project_prefix}-${var.environment}-api-gw-key"
    Project = var.project_prefix
    Environment = "${var.project_prefix}-${var.environment}"
  }

  api_gateway_usage_plan_name = "${var.project_prefix}-${var.environment}-api-gw-usage-plan"

  api_gateway_usage_plan_tags = {
    Name = "${var.project_prefix}-${var.environment}-api-gw-usage-plan"
    Project = var.project_prefix
    Environment = "${var.project_prefix}-${var.environment}"
  }

  deployed_at = var.api_gateway_deployed_at
}