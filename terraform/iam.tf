data "aws_iam_policy_document" "allow_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = [
        "lambda.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "lambda_invoke_function" {
  statement {
    sid       = "AllowLambdaInvokeFunction"
    effect    = "Allow"
    actions   = [
      "lambda:InvokeFunction"
    ]
    resources = [
      "*"
    ]
  }
}

#IAM role for the Lambda function to run under
resource "aws_iam_role" "lambda_uptime" {
  name_prefix        = "lambda-"
  tags = var.tags
  assume_role_policy = data.aws_iam_policy_document.allow_assume_role.json
}

resource "aws_iam_role_policy" "lambda-uptime-invoke" {
  name_prefix = "allow-uptime-lambda-invoke-"
  role        = aws_iam_role.lambda_uptime.id
  policy      = data.aws_iam_policy_document.lambda_invoke_function.json
}
