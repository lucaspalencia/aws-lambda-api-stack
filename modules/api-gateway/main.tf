# REST API
resource "aws_api_gateway_rest_api" "default" {
  name = var.api_gateway_rest_api_name
  tags = var.api_gateway_rest_api_tags
}

# RESOURCES
resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.default.id
  parent_id   = aws_api_gateway_rest_api.default.root_resource_id
  path_part   = "{proxy+}"
}

# METHODS
resource "aws_api_gateway_method" "any" {
  rest_api_id   = aws_api_gateway_rest_api.default.id
  resource_id   = aws_api_gateway_rest_api.default.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_method" "opt-method" {
  rest_api_id   = aws_api_gateway_rest_api.default.id
  resource_id   = aws_api_gateway_rest_api.default.root_resource_id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.default.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_method" "opt-proxy-method" {
  rest_api_id   = aws_api_gateway_rest_api.default.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# METHODS RESPONSE
resource "aws_api_gateway_method_response" "opt-method-response" {
  rest_api_id = aws_api_gateway_rest_api.default.id
  resource_id = aws_api_gateway_rest_api.default.root_resource_id
  http_method = aws_api_gateway_method.opt-method.http_method
  status_code = 200

   response_parameters =  { 
    "method.response.header.Access-Control-Allow-Headers" = false
    "method.response.header.Access-Control-Allow-Methods" = false
    "method.response.header.Access-Control-Allow-Origin"  = false
  }

  response_models = {
    "application/json" = "Empty"
  }

  depends_on = [
    aws_api_gateway_method.opt-method
  ]
}

resource "aws_api_gateway_method_response" "opt-proxy-method-response" {
  rest_api_id = aws_api_gateway_rest_api.default.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.opt-proxy-method.http_method
  status_code = 200

   response_parameters =  { 
    "method.response.header.Access-Control-Allow-Headers" = false
    "method.response.header.Access-Control-Allow-Methods" = false
    "method.response.header.Access-Control-Allow-Origin"  = false
  }

  response_models = {
    "application/json" = "Empty"
  }

  depends_on = [
    aws_api_gateway_method.opt-proxy-method
  ]
}

# INTEGRATIONS
resource "aws_api_gateway_integration" "main" {
  rest_api_id             = aws_api_gateway_rest_api.default.id
  resource_id             = aws_api_gateway_rest_api.default.root_resource_id
  http_method             = aws_api_gateway_method.any.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.uri
}

resource "aws_api_gateway_integration" "proxy" {
  rest_api_id             = aws_api_gateway_rest_api.default.id
  resource_id             = aws_api_gateway_resource.proxy.id
  http_method             = aws_api_gateway_method.proxy.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.uri
}

resource "aws_api_gateway_integration" "opt-integration" {
  rest_api_id = aws_api_gateway_rest_api.default.id
  resource_id = aws_api_gateway_rest_api.default.root_resource_id
  http_method = aws_api_gateway_method.opt-method.http_method
  content_handling = "CONVERT_TO_TEXT"

  type = "MOCK"

  request_templates = {
    "application/json" = "{ \"statusCode\": 200 }"
  }
}

resource "aws_api_gateway_integration" "opt-proxy-integration" {
  rest_api_id = aws_api_gateway_rest_api.default.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.opt-proxy-method.http_method
  content_handling = "CONVERT_TO_TEXT"

  type = "MOCK"

  request_templates = {
    "application/json" = "{ \"statusCode\": 200 }"
  }
}

# RESPONSE INTEGRATIONS
resource "aws_api_gateway_integration_response" "opt-integration-response" {
  rest_api_id = aws_api_gateway_rest_api.default.id
  resource_id = aws_api_gateway_rest_api.default.root_resource_id
  http_method = aws_api_gateway_method.opt-method.http_method
  status_code = 200

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_integration.opt-integration,
    aws_api_gateway_method_response.opt-method-response
  ]
}

resource "aws_api_gateway_integration_response" "opt-proxy-integration-response" {
  rest_api_id = aws_api_gateway_rest_api.default.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.opt-proxy-method.http_method
  status_code = 200

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_integration.opt-proxy-integration,
    aws_api_gateway_method_response.opt-proxy-method-response
  ]
}

# API KEYS
resource "aws_api_gateway_api_key" "api-key" {
  name = var.api_gateway_api_key_name
  tags = var.api_gateway_api_key_tags
}

# USAGE PLANS
resource "aws_api_gateway_usage_plan" "default" {
  name = var.api_gateway_usage_plan_name

  api_stages {
    api_id = aws_api_gateway_rest_api.default.id
    stage  = var.environment
  }

  quota_settings {
    limit  = 100
    period = "DAY"
  }

  throttle_settings {
    burst_limit = 5
    rate_limit  = 10
  }
  
  tags = var.api_gateway_usage_plan_tags
}

# USAGE PLANS KEYS
resource "aws_api_gateway_usage_plan_key" "main" {
  key_id        = aws_api_gateway_api_key.api-key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.default.id
}

# DEPLOY
resource "aws_api_gateway_deployment" "lambda_api" {
  rest_api_id = aws_api_gateway_rest_api.default.id
  stage_name  = var.environment

  variables = {
    deployed_at = var.deployed_at
  }

  depends_on = [
    aws_api_gateway_integration.main,
    aws_api_gateway_integration.opt-integration,
    aws_api_gateway_integration.proxy,
    aws_api_gateway_integration.opt-proxy-integration
  ]
}