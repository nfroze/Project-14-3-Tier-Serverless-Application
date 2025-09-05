# Configure S3 backend for state storage
terraform {
  backend "s3" {
    bucket = "project14-tfstate"
    key    = "serverless-3tier/terraform.tfstate"
    region = "eu-west-2"
  }
}