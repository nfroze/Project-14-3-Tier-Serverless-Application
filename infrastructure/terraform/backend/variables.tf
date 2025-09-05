variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "lambda_function_arns" {
  description = "ARNs of Lambda functions"
  type = object({
    get_all = string
    get_one = string
    create  = string
    update  = string
    delete  = string
  })
}

variable "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  type        = string
}

variable "api_gateway_execution_arn" {
  description = "Execution ARN of the API Gateway"
  type        = string
}