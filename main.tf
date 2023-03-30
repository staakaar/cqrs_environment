resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "estimationRequest"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "EstimationRequestId"
  range_key      = "Status"

  attribute {
    name = "EstimationRequestId"
    type = "S"
  }

  attribute {
    name = "Status"
    type = "S"
  }

  attribute {
    name = "desired_amount"
    type = "N"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  global_secondary_index {
    name               = "EstimationRequestIdIndex"
    hash_key           = "Status"
    range_key          = "desired_amount"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = []
  }

  tags = {
    Name        = "dynamodb-table-1"
    Environment = "development"
  }
}
