resource "aws_dynamodb_table" "employee_info" {
  name = "employee_info"
  billing_mode = "PROVISIONED"
  read_capacity = 20
  write_capacity = 20
  hash_key = "employeeid"

  attribute {
    name = "employeeid"
    type = "S"
  }
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role_python"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "basic_execution" {
  role = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "dynamo_full_access" {
  role = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_lambda_function" "python_script" {
    function_name = "python_script_lambda"
    filename = "./lambda_function.zip"
    runtime = "python3.13"
    handler = "lambda_function.lambda_handler"
    role = aws_iam_role.lambda_execution_role.arn
}

resource "aws_api_gateway_rest_api" "api_gateway" {
  name = "employeeInfoRestAPI"
}

resource "aws_api_gateway_resource" "employee_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part = "employee"
}

resource "aws_api_gateway_resource" "status_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part = "status"
}

resource "aws_api_gateway_method" "get_method" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.employee_resource.id
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "status_get_method" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.status_resource.id
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.employee_resource.id
  http_method = aws_api_gateway_method.get_method.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.python_script.invoke_arn
}

resource "aws_api_gateway_integration" "status_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  resource_id             = aws_api_gateway_resource.status_resource.id
  http_method             = aws_api_gateway_method.status_get_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.python_script.invoke_arn
}

resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.python_script.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api_gateway.execution_arn}/*/*"
}

resource "aws_lambda_permission" "status_api_gateway_permission" {
  statement_id  = "AllowAPIGatewayInvokeStatus"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.python_script.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api_gateway.execution_arn}/GET/status"
}

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [aws_api_gateway_integration.lambda_integration, aws_api_gateway_integration.status_lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  stage_name  = "dev"
}