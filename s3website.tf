resource "aws_s3_bucket" "s3website" {
  bucket = "www-${var.unique_identifier}-darklaunch-lambda-demosite"
}

resource "aws_s3_bucket_acl" "s3website_acl" {
  bucket     = aws_s3_bucket.s3website.id
  acl        = "public-read"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.s3website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [aws_s3_bucket_public_access_block.bucket_access_block]
}

resource "aws_s3_bucket_public_access_block" "bucket_access_block" {
  bucket = aws_s3_bucket.s3website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "s3website_config" {
  bucket = aws_s3_bucket.s3website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_cors_configuration" "s3website_cors" {
  bucket = aws_s3_bucket.s3website.id

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}

resource "aws_s3_bucket_policy" "s3website_policy" {
  bucket     = aws_s3_bucket.s3website.id
  policy     = data.aws_iam_policy_document.s3website_policy_doc.json
  depends_on = [aws_s3_bucket_public_access_block.bucket_access_block]
}

data "aws_iam_policy_document" "s3website_policy_doc" {
  statement {
    sid    = "PublicGetObject"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      aws_s3_bucket.s3website.arn,
      "${aws_s3_bucket.s3website.arn}/*",
    ]
  }
}

resource "aws_s3_object" "main_file" {
  bucket       = aws_s3_bucket.s3website.id
  key          = "index.html"
  source       = "${path.module}/apps/webapp/index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "jsfile_1" {
  bucket       = aws_s3_bucket.s3website.id
  key          = "main.js"
  source       = "${path.module}/apps/webapp/main.js"
  content_type = "text/javascript"
}

resource "aws_s3_object" "jsfile_2" {
  bucket       = aws_s3_bucket.s3website.id
  key          = "vars.js"
  source       = "${path.module}/apps/webapp/vars.js"
  content_type = "text/javascript"

  depends_on = [local_file.variable_js]
}

resource "local_file" "variable_js" {
  filename = "${path.module}/apps/webapp/vars.js"
  content  = <<CONTENT
apiDBValues = "${aws_api_gateway_deployment.dbvalues_deploy.invoke_url}";
apiIncrementer = "${aws_api_gateway_deployment.incrementer_deploy.invoke_url}";
apiIncrementLd = "${aws_api_gateway_deployment.incrementld_deploy.invoke_url}";
apiIncrementDb = "${aws_api_gateway_deployment.incrementdb_deploy.invoke_url}";
apiIncrementNone = "${aws_api_gateway_deployment.incrementnone_deploy.invoke_url}";
CONTENT
}
