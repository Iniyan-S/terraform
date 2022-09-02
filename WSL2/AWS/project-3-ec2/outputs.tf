output "iam-profile-s3-access" {
  value = aws_iam_instance_profile.instance-profile.name
}

output "s3-bucket" {
  value = aws_s3_bucket.terraform-ec2-bucket
}