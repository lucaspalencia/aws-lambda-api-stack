module "backend-api" {
  source           = "./modules/lambda"

  function_name    = "${var.project_prefix}-${var.environment}-lambda-api"
  runtime          = var.lambda_runtime
  memory_size      = var.lambda_memory_size
  timeout          = var.lambda_timeout
  role             = aws_iam_role.lambda_role.arn
  
  environment_variables = {
    "ENVIRONMENT"      = var.environment
  }

  tags = {
    Name        = "${var.project_prefix}-${var.environment}-lambda-api"
    Project     = var.project_prefix
    Environment = "${var.project_prefix}-${var.environment}"
  }
}