data "archive_file" "incrementer_zip" {
  type             = "zip"
  source_dir       = "${path.module}/apps/incrementer"
  excludes         = ["${path.module}/apps/incrementer/lambda_incrementer.zip"]
  output_file_mode = "0666"
  output_path      = "${path.module}/apps/incrementer/lambda_incrementer.zip"

  depends_on = [
    null_resource.ld_sdk_download
  ]
}

resource "aws_lambda_function" "lambda_incrementer" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "${path.module}/apps/incrementer/lambda_incrementer.zip"
  function_name = "${var.unique_identifier}_lambda_incrementer"
  role          = aws_iam_role.lambda_iam_role.arn
  handler       = "lambda_incrementer.lambda_handler"
  # source_code_hash = filebase64sha256("${path.module}/apps/incrementer/lambda_incrementer.zip")
  runtime = "python3.9"
  environment {
    variables = {
      SESSIONID  = "${var.unique_identifier}-session-id",
      LD_SDK_KEY = var.ld_sdk_key
      DDB_TABLE  = aws_dynamodb_table.item_tracker.name
    }
  }

  depends_on = [
    data.archive_file.incrementer_zip
  ]
}

resource "aws_cloudwatch_log_group" "lambda_log_incrementer" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_incrementer.function_name}"
  retention_in_days = 1
  lifecycle {
    prevent_destroy = false
  }
}

