# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "serverless-products-lambda-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for Lambda to access DynamoDB and CloudWatch
resource "aws_iam_role_policy" "lambda_policy" {
  name = "serverless-products-lambda-policy-${var.environment}"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan"
        ]
        Resource = var.dynamodb_table_arn
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# Lambda Functions

# Get All Products
resource "aws_lambda_function" "get_all_products" {
  filename         = "${path.module}/../../../backend/functions/products/get_all.zip"
  function_name    = "serverless-products-get-all-${var.environment}"
  role            = aws_iam_role.lambda_role.arn
  handler         = "get_all.handler"
  source_code_hash = filebase64sha256("${path.module}/../../../backend/functions/products/get_all.zip")
  runtime         = "python3.9"
  timeout         = 10

  environment {
    variables = {
      TABLE_NAME = "serverless-products-${var.environment}"
    }
  }
}

# Get One Product
resource "aws_lambda_function" "get_one_product" {
  filename         = "${path.module}/../../../backend/functions/products/get_one.zip"
  function_name    = "serverless-products-get-one-${var.environment}"
  role            = aws_iam_role.lambda_role.arn
  handler         = "get_one.handler"
  source_code_hash = filebase64sha256("${path.module}/../../../backend/functions/products/get_one.zip")
  runtime         = "python3.9"
  timeout         = 10

  environment {
    variables = {
      TABLE_NAME = "serverless-products-${var.environment}"
    }
  }
}

# Create Product
resource "aws_lambda_function" "create_product" {
  filename         = "${path.module}/../../../backend/functions/products/create.zip"
  function_name    = "serverless-products-create-${var.environment}"
  role            = aws_iam_role.lambda_role.arn
  handler         = "create.handler"
  source_code_hash = filebase64sha256("${path.module}/../../../backend/functions/products/create.zip")
  runtime         = "python3.9"
  timeout         = 10

  environment {
    variables = {
      TABLE_NAME = "serverless-products-${var.environment}"
    }
  }
}

# Update Product
resource "aws_lambda_function" "update_product" {
  filename         = "${path.module}/../../../backend/functions/products/update.zip"
  function_name    = "serverless-products-update-${var.environment}"
  role            = aws_iam_role.lambda_role.arn
  handler         = "update.handler"
  source_code_hash = filebase64sha256("${path.module}/../../../backend/functions/products/update.zip")
  runtime         = "python3.9"
  timeout         = 10

  environment {
    variables = {
      TABLE_NAME = "serverless-products-${var.environment}"
    }
  }
}

# Delete Product
resource "aws_lambda_function" "delete_product" {
  filename         = "${path.module}/../../../backend/functions/products/delete.zip"
  function_name    = "serverless-products-delete-${var.environment}"
  role            = aws_iam_role.lambda_role.arn
  handler         = "delete.handler"
  source_code_hash = filebase64sha256("${path.module}/../../../backend/functions/products/delete.zip")
  runtime         = "python3.9"
  timeout         = 10

  environment {
    variables = {
      TABLE_NAME = "serverless-products-${var.environment}"
    }
  }
}

# Lambda Permissions for API Gateway

resource "aws_lambda_permission" "get_all_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_all_products.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_gateway_execution_arn}/*/*"
}

resource "aws_lambda_permission" "get_one_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_one_product.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_gateway_execution_arn}/*/*"
}

resource "aws_lambda_permission" "create_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_product.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_gateway_execution_arn}/*/*"
}

resource "aws_lambda_permission" "update_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.update_product.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_gateway_execution_arn}/*/*"
}

resource "aws_lambda_permission" "delete_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete_product.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_gateway_execution_arn}/*/*"
}