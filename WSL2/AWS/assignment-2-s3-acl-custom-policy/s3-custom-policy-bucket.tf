# Create S3 Bucket

resource "aws_s3_bucket" "terraform-s3-bucket" {
    bucket = "terraform-s3-custom-policy-bucket"
    force_destroy = true  # Deletes even if objects are present

    tags = {
        Name = "Terraform S3 Custom Policy Bucket"
        "CreatedBy" = "Terraform"
    }  
}

# Enable S3 Bucket Versioning

resource "aws_s3_bucket_versioning" "enable-versioning" {
    bucket = aws_s3_bucket.terraform-s3-bucket.id
    versioning_configuration {
        status = "Enabled"
    }
}

# Enable Public Access via ACL

# resource "aws_s3_bucket_acl" "public-access" {
#     bucket = aws_s3_bucket.terraform-s3-bucket.id
#     access_control_policy {
#       grant {
#         grantee {
#           type = "Group"
#           uri = "http://acs.amazonaws.com/groups/global/AllUsers"
#         }
#         permission = "READ"
#       }

#       owner {
#         id = data.aws_canonical_user_id.current.id
#       }
#     }
# }

# resource "aws_s3_bucket_acl" "public-access" {
#   bucket = aws_s3_bucket.terraform-s3-bucket.id
#   acl = "public-read"
# }

# Attach IAM Policy Document to Bucket

resource "aws_s3_bucket_policy" "allow-access" {
  bucket = aws_s3_bucket.terraform-s3-bucket.id
  policy = data.aws_iam_policy_document.s3-access-definition.json
}