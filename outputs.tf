output "bucket_url" {
  value = aws_s3_bucket_website_configuration.s3website_config.website_endpoint
}
