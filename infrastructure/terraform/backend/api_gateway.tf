resource "aws_api_gateway_rest_api" "products_api" {
  name        = "serverless-products-api-${var.environment}"
  description = "Products API for 3-tier serverless application"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "products" {
  rest_api_id = aws_api_gateway_rest_api.products_api.id
  parent_id   = aws_api_gateway_rest_api.products_api.root_resource_id
  path_part   = "products"
}

resource "aws_api_gateway_resource" "product_id" {
  rest_api_id = aws_api_gateway_rest_api.products_api.id
  parent_id   = aws_api_gateway_resource.products.id
  path_part   = "{id}"
}

# GET all products
resource "aws_api_gateway_method" "get_products" {
  rest_api_id   = aws_api_gateway_rest_api.products_api.id
  resource_id   = aws_api_gateway_resource.products.id
  http_method   = "GET"
  authorization = "NONE"
}

# GET single product
resource "aws_api_gateway_method" "get_product" {
  rest_api_id   = aws_api_gateway_rest_api.products_api.id
  resource_id   = aws_api_gateway_resource.product_id.id
  http_method   = "GET"
  authorization = "NONE"
}

# POST new product
resource "aws_api_gateway_method" "create_product" {
  rest_api_id   = aws_api_gateway_rest_api.products_api.id
  resource_id   = aws_api_gateway_resource.products.id
  http_method   = "POST"
  authorization = "NONE"
}

# PUT update product
resource "aws_api_gateway_method" "update_product" {
  rest_api_id   = aws_api_gateway_rest_api.products_api.id
  resource_id   = aws_api_gateway_resource.product_id.id
  http_method   = "PUT"
  authorization = "NONE"
}

# DELETE product
resource "aws_api_gateway_method" "delete_product" {
  rest_api_id   = aws_api_gateway_rest_api.products_api.id
  resource_id   = aws_api_gateway_resource.product_id.id
  http_method   = "DELETE"
  authorization = "NONE"
}

# Deployment
resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.products_api.id

  depends_on = [
    aws_api_gateway_method.get_products,
    aws_api_gateway_method.get_product,
    aws_api_gateway_method.create_product,
    aws_api_gateway_method.update_product,
    aws_api_gateway_method.delete_product
  ]
}

resource "aws_api_gateway_stage" "api_stage" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.products_api.id
  stage_name    = var.environment
}

# GET all products integration
resource "aws_api_gateway_integration" "get_products_integration" {
  rest_api_id = aws_api_gateway_rest_api.products_api.id
  resource_id = aws_api_gateway_resource.products.id
  http_method = aws_api_gateway_method.get_products.http_method
  
  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = var.lambda_function_arns.get_all
}

# GET single product integration
resource "aws_api_gateway_integration" "get_product_integration" {
  rest_api_id = aws_api_gateway_rest_api.products_api.id
  resource_id = aws_api_gateway_resource.product_id.id
  http_method = aws_api_gateway_method.get_product.http_method
  
  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = var.lambda_function_arns.get_one
}

# POST product integration
resource "aws_api_gateway_integration" "create_product_integration" {
  rest_api_id = aws_api_gateway_rest_api.products_api.id
  resource_id = aws_api_gateway_resource.products.id
  http_method = aws_api_gateway_method.create_product.http_method
  
  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = var.lambda_function_arns.create
}

# PUT product integration
resource "aws_api_gateway_integration" "update_product_integration" {
  rest_api_id = aws_api_gateway_rest_api.products_api.id
  resource_id = aws_api_gateway_resource.product_id.id
  http_method = aws_api_gateway_method.update_product.http_method
  
  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = var.lambda_function_arns.update
}

# DELETE product integration
resource "aws_api_gateway_integration" "delete_product_integration" {
  rest_api_id = aws_api_gateway_rest_api.products_api.id
  resource_id = aws_api_gateway_resource.product_id.id
  http_method = aws_api_gateway_method.delete_product.http_method
  
  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = var.lambda_function_arns.delete
}

# CORS configuration
resource "aws_api_gateway_method" "options_products" {
  rest_api_id   = aws_api_gateway_rest_api.products_api.id
  resource_id   = aws_api_gateway_resource.products.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "options_product_id" {
  rest_api_id   = aws_api_gateway_rest_api.products_api.id
  resource_id   = aws_api_gateway_resource.product_id.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_products_integration" {
  rest_api_id = aws_api_gateway_rest_api.products_api.id
  resource_id = aws_api_gateway_resource.products.id
  http_method = aws_api_gateway_method.options_products.http_method
  type        = "MOCK"
  
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration" "options_product_id_integration" {
  rest_api_id = aws_api_gateway_rest_api.products_api.id
  resource_id = aws_api_gateway_resource.product_id.id
  http_method = aws_api_gateway_method.options_product_id.http_method
  type        = "MOCK"
  
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "options_products_response" {
  rest_api_id = aws_api_gateway_rest_api.products_api.id
  resource_id = aws_api_gateway_resource.products.id
  http_method = aws_api_gateway_method.options_products.http_method
  status_code = "200"
  
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_method_response" "options_product_id_response" {
  rest_api_id = aws_api_gateway_rest_api.products_api.id
  resource_id = aws_api_gateway_resource.product_id.id
  http_method = aws_api_gateway_method.options_product_id.http_method
  status_code = "200"
  
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "options_products_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.products_api.id
  resource_id = aws_api_gateway_resource.products.id
  http_method = aws_api_gateway_method.options_products.http_method
  status_code = aws_api_gateway_method_response.options_products_response.status_code
  
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_integration_response" "options_product_id_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.products_api.id
  resource_id = aws_api_gateway_resource.product_id.id
  http_method = aws_api_gateway_method.options_product_id.http_method
  status_code = aws_api_gateway_method_response.options_product_id_response.status_code
  
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,PUT,DELETE,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}