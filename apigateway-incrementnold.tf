resource "aws_api_gateway_rest_api" "incrementnold_endpoint" {
  name        = "${var.unique_identifier}_IncrementNoLDEndPoint"
  description = "Lambda IncrementNoLD Endpoint"
}

resource "aws_api_gateway_resource" "incrementnold_proxy_resource" {
  rest_api_id = aws_api_gateway_rest_api.incrementnold_endpoint.id
  parent_id   = aws_api_gateway_rest_api.incrementnold_endpoint.root_resource_id
  path_part   = "{proxy+}"
}

/***************************************/
/*             BEGIN CORS              */
/***************************************/

resource "aws_api_gateway_method" "incrementnold_options_method" {
  rest_api_id   = aws_api_gateway_rest_api.incrementnold_endpoint.id
  resource_id   = aws_api_gateway_rest_api.incrementnold_endpoint.root_resource_id
  http_method   = "OPTIONS"
  authorization = "NONE"
}
resource "aws_api_gateway_method_response" "incrementnold_options_response" {
  rest_api_id = aws_api_gateway_rest_api.incrementnold_endpoint.id
  resource_id = aws_api_gateway_rest_api.incrementnold_endpoint.root_resource_id
  http_method = aws_api_gateway_method.incrementnold_options_method.http_method
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

resource "aws_api_gateway_integration" "incrementnold_options_integration" {
  rest_api_id      = aws_api_gateway_rest_api.incrementnold_endpoint.id
  resource_id      = aws_api_gateway_rest_api.incrementnold_endpoint.root_resource_id
  http_method      = aws_api_gateway_method.incrementnold_options_method.http_method
  content_handling = "CONVERT_TO_TEXT"
  type             = "MOCK"
  request_templates = {
    "application/json" = "{ \"statusCode\": 200 }"
  }
}

resource "aws_api_gateway_integration_response" "incrementnold_options_int_response" {
  rest_api_id = aws_api_gateway_rest_api.incrementnold_endpoint.id
  resource_id = aws_api_gateway_rest_api.incrementnold_endpoint.root_resource_id
  http_method = aws_api_gateway_method.incrementnold_options_method.http_method
  status_code = aws_api_gateway_method_response.incrementnold_options_response.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

/***************************************/
/*              END CORS               */
/***************************************/


resource "aws_api_gateway_method" "incrementnold_proxy_method" {
  rest_api_id   = aws_api_gateway_rest_api.incrementnold_endpoint.id
  resource_id   = aws_api_gateway_resource.incrementnold_proxy_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "incrementnold_proxy_method_resp" {
  rest_api_id = aws_api_gateway_rest_api.incrementnold_endpoint.id
  resource_id = aws_api_gateway_resource.incrementnold_proxy_resource.id
  http_method = aws_api_gateway_method.incrementnold_proxy_method.http_method
  status_code = 200
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration" "incrementnold_invoke" {
  rest_api_id = aws_api_gateway_rest_api.incrementnold_endpoint.id
  resource_id = aws_api_gateway_method.incrementnold_proxy_method.resource_id
  http_method = aws_api_gateway_method.incrementnold_proxy_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_incrementnold.invoke_arn
}

resource "aws_api_gateway_method" "incrementnold_proxy_method_root" {
  rest_api_id   = aws_api_gateway_rest_api.incrementnold_endpoint.id
  resource_id   = aws_api_gateway_rest_api.incrementnold_endpoint.root_resource_id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "incrementnold_invoke_root" {
  rest_api_id = aws_api_gateway_rest_api.incrementnold_endpoint.id
  resource_id = aws_api_gateway_method.incrementnold_proxy_method_root.resource_id
  http_method = aws_api_gateway_method.incrementnold_proxy_method_root.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_incrementnold.invoke_arn
}

resource "aws_api_gateway_deployment" "incrementnold_deploy" {
  depends_on = [
    aws_api_gateway_integration.incrementnold_invoke,
    aws_api_gateway_integration.incrementnold_invoke_root
  ]

  rest_api_id = aws_api_gateway_rest_api.incrementnold_endpoint.id
  stage_name  = "${var.unique_identifier}-test"
}

resource "aws_lambda_permission" "api_gateway_incrementnold_perms" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_incrementnold.function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.incrementnold_endpoint.execution_arn}/*/*"
}
