# This bucket will be used to store terraform.tfstate file for remote backend

# Bucket Creation
resource "aws_s3_bucket" "remote-store" {
  bucket = "terraform-state-remote-store"
  # When object lock is enabled, versioning is enabled automatically, no need to enable it explicitly 
  # object_lock_enabled = true # To customize object lock configuration use resource block "resource aws_s3_bucket_object_lock_configuration"

  tags = {
    Name = "Terraform State Remote Store"
  }
}

# Declare Object Lock Configuration
# e.g.
# resource "aws_s3_bucket_object_lock_configuration" "example" {
#   bucket = aws_s3_bucket.example.bucket

#   rule {
#     default_retention {
#       mode = "COMPLIANCE"
#       days = 5
#     }
#   }
# }

# # Declare ACL
# resource "aws_s3_bucket_acl" "acl" {
#   bucket = aws_s3_bucket.remote-store.id
#   acl = "private"
# }

# Enable Versioning
resource "aws_s3_bucket_versioning" "enable_versioning" {
    bucket = aws_s3_bucket.remote-store.id
    versioning_configuration {
      status = "Enabled"
    } 
}