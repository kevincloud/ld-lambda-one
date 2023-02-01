data "archive_file" "incrementnone_zip" {
  type             = "zip"
  source_dir       = "${path.module}/apps/incrementnone"
  excludes         = ["${path.module}/apps/incrementnone/lambda_incrementnone.zip"]
  output_file_mode = "0666"
  output_path      = "${path.module}/apps/incrementnone/lambda_incrementnone.zip"
}

resource "aws_lambda_function" "lambda_incrementnone" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename         = "${path.module}/apps/incrementnone/lambda_incrementnone.zip"
  function_name    = local.incrementnone_fname
  role             = aws_iam_role.lambda_iam_role.arn
  handler          = "lambda_incrementnone.lambda_handler"
  source_code_hash = data.archive_file.incrementnone_zip.output_base64sha256
  runtime          = "python3.9"
  environment {
    variables = {
      SESSIONID  = "${var.unique_identifier}-session-id"
      LD_SDK_KEY = var.ld_sdk_key
      DDB_TABLE  = aws_dynamodb_table.item_tracker.name
      LOG_GROUP  = local.incrementnone_loggroup
    }
  }

  depends_on = [
    data.archive_file.incrementnone_zip
  ]
}

resource "aws_cloudwatch_log_group" "lambda_log_incrementnone" {
  name              = local.incrementnone_loggroup
  retention_in_days = 1
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_cloudwatch_log_stream" "lambda_logstream_incrementnone" {
  name           = "ApplicationLogs"
  log_group_name = aws_cloudwatch_log_group.lambda_log_incrementnone.name
}
