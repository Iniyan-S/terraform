# Create IAM Role

resource "aws_iam_role" "ec2-s3-role" {
  name = "EC2-S3-Access-Role"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
  tags = {
    "Name" = "s3-access"
    "CreatedBy" = "Terraform"
  }
  
}

# Create IAM Policy

resource "aws_iam_policy" "s3-access" {
    name = "Terraform-EC2-Bucket-Access"
    path = "/"
    description = "Policy to give access to terraform-ec2-access"

    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:ListBucketMultipartUploads",
                "s3:ListBucketVersions",
                "s3:ListBucket",
                "s3:ListMultipartUploadParts"
            ],
            "Resource": [
                "arn:aws:s3:::terraform-ec2-bucket/*",
                "arn:aws:s3:::terraform-ec2-bucket"
            ]
        }
    ]
}

EOF
    tags = {
      "CreateBy" = "Terraform"
      "Name" = "Terraform-EC2-Bucket-Access"
    }
}

# Attach above created Policy & IAM Role

resource "aws_iam_role_policy_attachment" "ec2-attach" {
  role = aws_iam_role.ec2-s3-role.name
  policy_arn = aws_iam_policy.s3-access.arn
}

# Create IAM Instance Profile 
# Updating the Resource Type from arn:aws:iam::606109582808:role/EC2-S3-Access-Role to arn:aws:iam::606109582808:instance-profile/EC2-S3-Access-Role
# Creating IAM Role to assume "Service": "ec2.amazonaws.com" by default it doesn't create the resource (role) as "instance-profile" resource
# So it can be attached to EC2 instance

resource "aws_iam_instance_profile" "instance-profile" {
  name = "ec2-s3-access-role"
  role = aws_iam_role.ec2-s3-role.name
}