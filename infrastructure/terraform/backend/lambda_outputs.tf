output "lambda_function_arns" {
  value = {
    get_all = aws_lambda_function.get_all_products.invoke_arn
    get_one = aws_lambda_function.get_one_product.invoke_arn
    create  = aws_lambda_function.create_product.invoke_arn
    update  = aws_lambda_function.update_product.invoke_arn
    delete  = aws_lambda_function.delete_product.invoke_arn
  }
}