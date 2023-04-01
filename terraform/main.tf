terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.61.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "OrderHistory"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "OrderId"
  range_key      = "Status"

  attribute {
    name = "OrderId"
    type = "S"
  }

  attribute {
    name = "Status"
    type = "S"
  }

  attribute {
    name = "item"
    type = "N"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  global_secondary_index {
    name               = "OrderIdIndex"
    hash_key           = "Status"
    range_key          = "item"
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

/**
  DynamoDB AutoScaling
*/

resource "aws_appautoscaling_target" "dynamodb_table_read_target" {
  max_capacity       = 100
  min_capacity       = 5
  resource_id        = "table/tableName"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb_table_read_policy" {
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_read_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.dynamodb_table_read_target.resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb_table_read_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.dynamodb_table_read_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    /** ターゲット使用率 */
    target_value = 70
  }
}