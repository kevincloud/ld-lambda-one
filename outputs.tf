output "website_url" {
  value = "http://${aws_s3_bucket_website_configuration.s3website_config.website_endpoint}"
}
