variable "sites" {
  type    = list(string)
  default = ["https://api.hocam.app/dashboard", "https://hocam.app"]
}

variable "slack_webhook_url" {}

variable "lambda_run_frequency" {
  type    = string
  default = "5 minutes"
}

variable "tags" {
  type = map(string)

  default = {
    Name         = "Uptime Lambda Function"
    service      = "uptime"
    service_type = "monitoring"
    Purpose      = "monitoring"
    created_by   = "Terraform"
  }
}
