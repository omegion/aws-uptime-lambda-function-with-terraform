## AWS Uptime Monitoring Lambda Function with Terraform

This terraform module helps you to monitor your sites. It will be trigger every 5 minutes to check your website.

### Setup
Go to lambda directory and run following command. It will build Go package and zip it.
```bash
make cleanup
make build
make package
```
Then, go to terraform directory, set following environments with your AWS creds and Slack webhook url.
```bash
export AWS_ACCESS_KEY_ID="key"
export AWS_SECRET_ACCESS_KEY="secret"
export AWS_DEFAULT_REGION="us-east-1"
export TF_VAR_slack_webhook_url="webhook-url"
```

After setting the creds, run Terraform to deploy the lambda function
lambda directory.
```bash
terraform apply
```
