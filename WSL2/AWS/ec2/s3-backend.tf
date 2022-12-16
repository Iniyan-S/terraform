# Define S3 Backend Details 

terraform {
  backend "s3" {
    bucket = "terraform-state-remote-store"
    key = "dev/ec2/terraform.tfstate"
    dynamodb_table = "terraform-state-lock-table"
    region = "ap-south-1"
  }
} 