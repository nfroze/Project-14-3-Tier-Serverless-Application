output "api_url" {
  value       = module.backend.api_url
  description = "API Gateway URL"
}

output "frontend_url" {
  value       = module.frontend.cloudfront_url
  description = "CloudFront URL for frontend"
}

output "s3_bucket_name" {
  value       = module.frontend.s3_bucket_name
  description = "S3 bucket name for frontend deployment"
}

output "cloudfront_distribution_id" {
  value       = module.frontend.cloudfront_distribution_id
  description = "CloudFront distribution ID"
}