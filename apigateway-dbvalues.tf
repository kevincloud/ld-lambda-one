resource "aws_api_gateway_rest_api" "dbvalues_endpoint" {
  name        = "${var.unique_identifier}_DBValuesEndPoint"
  description = "Lambda DBValues Endpoint"
}

resource "aws_api_gateway_resource" "dbvalues_proxy_resource" {
  rest_api_id = aws_api_gateway_rest_api.dbvalues_endpoint.id
  parent_id   = aws_api_gateway_rest_api.dbvalues_endpoint.root_resource_id
  path_part   = "{proxy+}"
}

/***************************************/
/*             BEGIN CORS              */
/***************************************/

resource "aws_api_gateway_method" "dbvalues_options_method" {
  rest_api_id   = aws_api_gateway_rest_api.dbvalues_endpoint.id
  resource_id   = aws_api_gateway_rest_api.dbvalues_endpoint.root_resource_id
  http_method   = "OPTIONS"
  authorization = "NONE"
}
resource "aws_api_gateway_method_response" "dbvalues_options_response" {
  rest_api_id = aws_api_gateway_rest_api.dbvalues_endpoint.id
  resource_id = aws_api_gateway_rest_api.dbvalues_endpoint.root_resource_id
  http_method = aws_api_gateway_method.dbvalues_options_method.http_method
  status_code = 200
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration" "dbvalues_options_integration" {
  rest_api_id      = aws_api_gateway_rest_api.dbvalues_endpoint.id
  resource_id      = aws_api_gateway_rest_api.dbvalues_endpoint.root_resource_id
  http_method      = aws_api_gateway_method.dbvalues_options_method.http_method
  content_handling = "CONVERT_TO_TEXT"
  type             = "MOCK"
  request_templates = {
    "application/json" = "{ \"statusCode\": 200 }"
  }
}

resource "aws_api_gateway_integration_response" "dbvalues_options_int_response" {
  rest_api_id = aws_api_gateway_rest_api.dbvalues_endpoint.id
  resource_id = aws_api_gateway_rest_api.dbvalues_endpoint.root_resource_id
  http_method = aws_api_gateway_method.dbvalues_options_method.http_method
  status_code = aws_api_gateway_method_response.dbvalues_options_response.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

/***************************************/
/*              END CORS               */
/***************************************/

resource "aws_api_gateway_method" "dbvalues_proxy_method" {
  rest_api_id   = aws_api_gateway_rest_api.dbvalues_endpoint.id
  resource_id   = aws_api_gateway_resource.dbvalues_proxy_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "dbvalues_proxy_method_resp" {
  rest_api_id = aws_api_gateway_rest_api.dbvalues_endpoint.id
  resource_id = aws_api_gateway_resource.dbvalues_proxy_resource.id
  http_method = aws_api_gateway_method.dbvalues_proxy_method.http_method
  status_code = 200
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration" "dbvalues_invoke" {
  rest_api_id = aws_api_gateway_rest_api.dbvalues_endpoint.id
  resource_id = aws_api_gateway_method.dbvalues_proxy_method.resource_id
  http_method = aws_api_gateway_method.dbvalues_proxy_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_dbvalues.invoke_arn
}

resource "aws_api_gateway_method" "dbvalues_proxy_method_root" {
  rest_api_id   = aws_api_gateway_rest_api.dbvalues_endpoint.id
  resource_id   = aws_api_gateway_rest_api.dbvalues_endpoint.root_resource_id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "dbvalues_invoke_root" {
  rest_api_id = aws_api_gateway_rest_api.dbvalues_endpoint.id
  resource_id = aws_api_gateway_method.dbvalues_proxy_method_root.resource_id
  http_method = aws_api_gateway_method.dbvalues_proxy_method_root.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_dbvalues.invoke_arn
}

resource "aws_api_gateway_deployment" "dbvalues_deploy" {
  depends_on = [
    aws_api_gateway_integration.dbvalues_invoke,
    aws_api_gateway_integration.dbvalues_invoke_root
  ]

  rest_api_id = aws_api_gateway_rest_api.dbvalues_endpoint.id
  stage_name  = "${var.unique_identifier}-test"
}

resource "aws_lambda_permission" "api_gateway_dbvalues_perms" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_dbvalues.function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.dbvalues_endpoint.execution_arn}/*/*"
}
