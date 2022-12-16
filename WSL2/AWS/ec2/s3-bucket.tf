# Create S3 Bucket

resource "aws_s3_bucket" "terraform-ec2-bucket" {
  bucket = "terraform-ec2-bucket"
  tags = {
    "Name" = "Terraform EC2 Bucket"
    "CreateBy" = "Terraform"
  }
}