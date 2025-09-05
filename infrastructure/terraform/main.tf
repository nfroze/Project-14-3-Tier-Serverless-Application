# Database Module
module "database" {
  source      = "./database"
  environment = var.environment
}

# Backend Module (Lambda + API Gateway)
module "backend" {
  source                    = "./backend"
  environment              = var.environment
  dynamodb_table_arn       = module.database.table_arn
  api_gateway_execution_arn = module.backend.api_gateway_execution_arn
  lambda_function_arns     = module.backend.lambda_function_arns
}

# Frontend Module
module "frontend" {
  source      = "./frontend"
  environment = var.environment
}