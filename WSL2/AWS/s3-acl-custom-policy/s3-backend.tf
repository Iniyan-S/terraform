terraform {
  backend "s3" {
    bucket = "terraform-state-remote-store"
    key = "dev/assign-2-s3/terraform.tfstate"
    dynamodb_table = "terraform-state-lock-table"
    region = "ap-south-1"
  }
}