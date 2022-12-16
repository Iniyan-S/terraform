# Create Topic

resource "aws_sns_topic" "cpu-alerts-topic" {
  name = "cpu-usage-alerts"

  tags = {
    "Name" = "CPU Usage Alerts"
    "CreateBy" = "Terraform"
  }
}

# Create Subscription

resource "aws_sns_topic_subscription" "cpu-alerts-sub" {
  topic_arn = aws_sns_topic.cpu-alerts-topic.arn
  protocol = "email"
  endpoint = "iniyansargunam@gmail.com"
}

output "email-confirmation-status" {
  value = aws_sns_topic_subscription.cpu-alerts-sub.confirmation_was_authenticated
}