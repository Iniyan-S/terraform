# Create DynamoDB table with LockID as Partition key to use with Terraform State File locking in S3 bucket

resource "aws_dynamodb_table" "terraform-state-lock" {
  name = "terraform-state-lock-table"
  billing_mode = "PROVISIONED"
  read_capacity = "5"   # If set 5, it can be used within AWS free tier
  write_capacity = "5"  # If set 5, it can be used within AWS free tier
  # Partition Key
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"    # S stands for String type
  }

  tags = {
    "Name" = "Terraform State File Lock Table"
  }
}

# Alternatively billing_mode = "PAY_PER_REQUEST" can be set, which is pay as you go model and doesn't require read & write capacity
# Reason for setting Partition Key (hash_key = "LockID") is taken from Terraform documentation
# https://www.terraform.io/language/settings/backends/s3
# The table must have a partition key named LockID with type of String. If not configured, state locking will be disabled.
