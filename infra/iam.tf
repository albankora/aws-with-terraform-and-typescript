data "aws_iam_policy_document" "lambda" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "sqs_event_router_lambda" {
  assume_role_policy = data.aws_iam_policy_document.lambda.json
}

resource "aws_iam_role_policy_attachment" "sqs_event_router_lambda" {
  role       = aws_iam_role.sqs_event_router_lambda.name
  policy_arn = aws_iam_policy.sqs_event_router_lambda.arn
}

resource "aws_iam_policy" "sqs_event_router_lambda" {
  policy = data.aws_iam_policy_document.sqs_event_router_lambda.json
}

data "aws_iam_policy_document" "sqs_event_router_lambda" {

  statement {
    sid       = "ReadWriteTable"
    effect    = "Allow"
    resources = ["arn:aws:dynamodb:*:*:table/${var.events_table}-${var.environment}"]

    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:BatchWriteItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem"
    ]
  }

  statement {
    sid       = "AllowPutEventsPermissions"
    effect    = "Allow"
    resources = ["arn:aws:events:${var.region}:*:event-bus/*"]
    actions   = ["events:PutEvents"]
  }

  statement {
    sid       = "AllowSQSPermissions"
    effect    = "Allow"
    resources = ["arn:aws:sqs:*"]

    actions = [
      "sqs:ChangeMessageVisibility",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:ReceiveMessage",
    ]
  }

  statement {
    sid       = "AllowInvokingLambdas"
    effect    = "Allow"
    resources = ["arn:aws:lambda:${var.region}:*:function:*"]
    actions   = ["lambda:InvokeFunction"]
  }

  statement {
    sid       = "AllowCreatingLogGroups"
    effect    = "Allow"
    resources = ["arn:aws:logs:${var.region}:*:*"]
    actions   = ["logs:CreateLogGroup"]
  }

  statement {
    sid       = "AllowWritingLogs"
    effect    = "Allow"
    resources = ["arn:aws:logs:${var.region}:*:log-group:/aws/lambda/*:*"]

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
}

resource "aws_iam_role" "order_event_processor_lambda" {
  assume_role_policy = data.aws_iam_policy_document.lambda.json
}

resource "aws_iam_role_policy_attachment" "order_event_processor_lambda" {
  role       = aws_iam_role.order_event_processor_lambda.name
  policy_arn = aws_iam_policy.order_event_processor_lambda.arn
}

resource "aws_iam_policy" "order_event_processor_lambda" {
  policy = data.aws_iam_policy_document.order_event_processor_lambda.json
}

data "aws_iam_policy_document" "order_event_processor_lambda" {
  statement {
    sid       = "ReadWriteTable"
    effect    = "Allow"
    resources = ["arn:aws:dynamodb:*:*:table/${var.orders_table}-${var.environment}"]

    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:BatchWriteItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem"
    ]
  }

  statement {
    sid       = "AllowCreatingLogGroups"
    effect    = "Allow"
    resources = ["arn:aws:logs:${var.region}:*:*"]
    actions   = ["logs:CreateLogGroup"]
  }

  statement {
    sid       = "AllowWritingLogs"
    effect    = "Allow"
    resources = ["arn:aws:logs:${var.region}:*:log-group:/aws/lambda/*:*"]

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
}

resource "aws_iam_role" "product_event_processor_lambda" {
  assume_role_policy = data.aws_iam_policy_document.lambda.json
}

resource "aws_iam_role_policy_attachment" "product_event_processor_lambda" {
  role       = aws_iam_role.product_event_processor_lambda.name
  policy_arn = aws_iam_policy.product_event_processor_lambda.arn
}

resource "aws_iam_policy" "product_event_processor_lambda" {
  policy = data.aws_iam_policy_document.product_event_processor_lambda.json
}

data "aws_iam_policy_document" "product_event_processor_lambda" {

  statement {
    sid       = "ReadWriteTable"
    effect    = "Allow"
    resources = ["arn:aws:dynamodb:*:*:table/${var.products_table}-${var.environment}"]

    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:BatchWriteItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem"
    ]
  }
  statement {
    sid       = "AllowCreatingLogGroups"
    effect    = "Allow"
    resources = ["arn:aws:logs:${var.region}:*:*"]
    actions   = ["logs:CreateLogGroup"]
  }

  statement {
    sid       = "AllowWritingLogs"
    effect    = "Allow"
    resources = ["arn:aws:logs:${var.region}:*:log-group:/aws/lambda/*:*"]

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
}

data "aws_iam_policy_document" "event_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "product_event_processor_rule" {
  assume_role_policy = data.aws_iam_policy_document.event_assume_role.json
}

resource "aws_iam_role" "order_event_processor_rule" {
  assume_role_policy = data.aws_iam_policy_document.event_assume_role.json
}

resource "aws_iam_role_policy_attachment" "product_event_processor_rule" {
  role       = aws_iam_role.product_event_processor_rule.name
  policy_arn = aws_iam_policy.product_event_processor_rule.arn
}

resource "aws_iam_role_policy_attachment" "order_event_processor_rule" {
  role       = aws_iam_role.order_event_processor_rule.name
  policy_arn = aws_iam_policy.order_event_processor_rule.arn
}

resource "aws_iam_policy" "order_event_processor_rule" {
  policy = data.aws_iam_policy_document.allow_kinesis_put.json
}

resource "aws_iam_policy" "product_event_processor_rule" {
  policy = data.aws_iam_policy_document.allow_kinesis_put.json
}

data "aws_iam_policy_document" "allow_kinesis_put" {
  statement {
    sid       = "AllowKinesisPut"
    effect    = "Allow"
    resources = ["arn:aws:kinesis:*:*:*"]

    actions = [
      "kinesis:PutRecord",
      "kinesis:PutRecords"
    ]
  }
}

data "aws_iam_policy_document" "api_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "api" {
  assume_role_policy = data.aws_iam_policy_document.api_role.json
}

resource "aws_iam_role_policy_attachment" "api" {
  role       = aws_iam_role.api.name
  policy_arn = aws_iam_policy.api.arn
}

resource "aws_iam_policy" "api" {
  policy = data.aws_iam_policy_document.api_policy.json
}

data "aws_iam_policy_document" "api_policy" {
  statement {
    sid       = "ReadWriteTable"
    effect    = "Allow"
    resources = ["arn:aws:dynamodb:*:*:table/${var.orders_table}-${var.environment}", "arn:aws:dynamodb:*:*:table/${var.products_table}-${var.environment}"]

    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:Scan"
    ]
  }
}
