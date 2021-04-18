data "archive_file" "lambda_api" {
  type        = "zip"
  source_file = "${path.module}/functions/index.js"
  output_path = "${path.module}/functions/index.zip"
}

resource "aws_lambda_function" "lambda_api" {
  function_name    = var.function_name
  filename         = data.archive_file.lambda_api.output_path
  handler          = var.handler
  runtime          = var.runtime
  memory_size      = var.memory_size
  timeout          = var.timeout
  role             = var.role

  environment {
    variables = var.environment_variables
  } 

  tags = var.tags
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_api.arn
  principal = "apigateway.amazonaws.com"
}