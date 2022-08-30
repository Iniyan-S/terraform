# Get Current Canonical User ID

data "aws_canonical_user_id" "current" {}

output "canonical_user_id" {
  value = data.aws_canonical_user_id.current.id
}

# Create Bucket Policy to Allow Access from Specific IP
# Ref: 
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
# https://www.cloud-plusplus.com/post/aws-s3-bucket-access-to-specific-ip
# https://docs.aws.amazon.com/AmazonS3/latest/userguide/example-bucket-policies.html
# https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_condition_operators.html#Conditions_IPAddress

data "aws_iam_policy_document" "s3-access-definition" {
  statement {
    sid = "IPAllow"

    effect = "Allow"

    principals {
      type = "*"
      identifiers = ["*"]
    }

    actions = [ 
        "s3:GetObject", 
        ]

    resources = [ 
        "arn:aws:s3:::terraform-s3-custom-policy-bucket",
        "arn:aws:s3:::terraform-s3-custom-policy-bucket/*",
        ]
    
    condition {
      test = "IpAddress"
      variable = "aws:SourceIp"
      values = [ "115.99.14.220/32" ]
    }

  }
}