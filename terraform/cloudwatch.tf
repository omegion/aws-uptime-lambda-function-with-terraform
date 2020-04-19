resource "aws_cloudwatch_event_rule" "uptime_lambda_trigger" {
  name = "uptime-lambda-function-trigger"
  description = "Trigger Uptime Lambda function every ${var.lambda_run_frequency}"
  schedule_expression = "rate(${var.lambda_run_frequency})"
}

resource "aws_cloudwatch_event_target" "uptime_lambda_event_target" {
  target_id = "uptime_lambda_event_trigger"
  arn = aws_lambda_function.uptime.arn
  rule = aws_cloudwatch_event_rule.uptime_lambda_trigger.name
}
