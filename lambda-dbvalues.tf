data "archive_file" "dbvalues_zip" {
  type             = "zip"
  source_file      = "${path.module}/apps/dbvalues/lambda_dbvalues.py"
  output_file_mode = "0666"
  output_path      = "${path.module}/apps/dbvalues/lambda_dbvalues.zip"
}

resource "aws_lambda_function" "lambda_dbvalues" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "${path.module}/apps/dbvalues/lambda_dbvalues.zip"
  function_name = "${var.unique_identifier}_lambda_dbvalues"
  role          = aws_iam_role.lambda_iam_role.arn
  handler       = "lambda_dbvalues.lambda_handler"
  # source_code_hash = filebase64sha256("${path.module}/apps/dbvalues/lambda_dbvalues.zip")
  runtime = "python3.9"
  environment {
    variables = {
      SESSIONID  = "${var.unique_identifier}-session-id",
      LD_SDK_KEY = var.ld_sdk_key
      DDB_TABLE  = aws_dynamodb_table.item_tracker.name
    }
  }

  depends_on = [data.archive_file.dbvalues_zip]
}

resource "aws_cloudwatch_log_group" "lambda_log_dbvalues" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_dbvalues.function_name}"
  retention_in_days = 1
  lifecycle {
    prevent_destroy = false
  }
}

