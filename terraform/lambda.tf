resource "aws_lambda_permission" "from_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.uptime.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.uptime_lambda_trigger.arn
}

resource "aws_lambda_function" "uptime" {
  filename         = "../lambda/deployment.zip"
  function_name    = "uptime_lambda_function"
  role             = aws_iam_role.lambda_uptime.arn
  handler          = "main"
  source_code_hash = filebase64sha256("../lambda/deployment.zip")
  runtime          = "go1.x"
  timeout          = "10"

  environment {
    variables = {
      RUN_LAMBDA        = "true"
      RUN_CLI           = "false"
      SITES             = join(",", var.sites)
      SLACK_WEBHOOK_URL = var.slack_webhook_url
    }
  }

  tags = var.tags

}
