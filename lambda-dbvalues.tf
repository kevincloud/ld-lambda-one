data "archive_file" "dbvalues_zip" {
  type             = "zip"
  source_file      = "${path.module}/apps/dbvalues/lambda_dbvalues.py"
  output_file_mode = "0666"
  output_path      = "${path.module}/apps/dbvalues/lambda_dbvalues.zip"
}

resource "aws_lambda_function" "lambda_dbvalues" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename         = "${path.module}/apps/dbvalues/lambda_dbvalues.zip"
  function_name    = local.dbvalues_fname
  role             = aws_iam_role.lambda_iam_role.arn
  handler          = "lambda_dbvalues.lambda_handler"
  source_code_hash = data.archive_file.dbvalues_zip.output_base64sha256
  runtime          = "python3.9"
  environment {
    variables = {
      SESSIONID  = "${var.unique_identifier}-session-id"
      LD_SDK_KEY = var.ld_sdk_key
      DDB_TABLE  = aws_dynamodb_table.item_tracker.name
      LOG_GROUP  = local.dbvalues_loggroup
    }
  }

  depends_on = [data.archive_file.dbvalues_zip]
}

resource "aws_lambda_function_url" "lambda_dbvalues_url" {
  function_name      = aws_lambda_function.lambda_dbvalues.arn
  authorization_type = "NONE"

  cors {
    allow_credentials = false
    allow_origins     = ["*"]
    allow_methods     = ["POST", "GET"]
    allow_headers     = ["*"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }

  depends_on = [aws_lambda_function.lambda_dbvalues]
}



resource "aws_cloudwatch_log_group" "lambda_log_dbvalues" {
  name              = local.dbvalues_loggroup
  retention_in_days = 1
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_cloudwatch_log_stream" "lambda_logstream_dbvalues" {
  name           = "ApplicationLogs"
  log_group_name = aws_cloudwatch_log_group.lambda_log_dbvalues.name
}
