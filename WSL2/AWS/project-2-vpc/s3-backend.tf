# Define S3 Backend Details 

terraform {
  backend "s3" {
    bucket = "terraform-state-remote-store"
    key = "dev/vpc/terraform.tfstate"
    dynamodb_table = "terraform-state-lock-table"
    region = "ap-south-1"
  }
} 