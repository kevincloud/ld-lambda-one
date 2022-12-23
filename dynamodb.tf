resource "aws_dynamodb_table" "item_tracker" {
  name           = "${var.unique_identifier}-item-tracker"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "SessionId"

  attribute {
    name = "SessionId"
    type = "S"
  }

  tags = {
    Name  = "${var.unique_identifier}-item-tracker"
    owner = var.owner
  }
}

resource "aws_dynamodb_table_item" "initial_ddb_item" {
  table_name = aws_dynamodb_table.item_tracker.name
  hash_key   = aws_dynamodb_table.item_tracker.hash_key

  item = <<ITEM
{
    "SessionId": {"S": "${var.unique_identifier}-session-id"},
    "NumberItem": {"N": "1"},
    "AlphaItem": {"S": "A"}
}
ITEM
}
