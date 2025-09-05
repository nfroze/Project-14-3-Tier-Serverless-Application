# Script to deploy React app to S3
param(
    [string]$BucketName,
    [string]$DistributionId
)

# Build React app
Write-Host "Building React app..." -ForegroundColor Green
Set-Location ../../../frontend/react-app
npm run build

# Upload to S3
Write-Host "Uploading to S3..." -ForegroundColor Green
aws s3 sync dist/ s3://$BucketName --delete

# Invalidate CloudFront cache
Write-Host "Invalidating CloudFront cache..." -ForegroundColor Green
aws cloudfront create-invalidation --distribution-id $DistributionId --paths "/*"

Write-Host "Deployment complete!" -ForegroundColor Green