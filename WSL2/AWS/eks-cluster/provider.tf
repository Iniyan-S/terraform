# Add Provider

provider "aws" {
  region = "ap-south-1"

  default_tags {
    tags = {
      CreatedBy = "Terraform"
    }
  }
}