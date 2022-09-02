# Configure Datasource to use VPC information from Remote S3 Backend to read state file outputs

data "terraform_remote_state" "myvpc" {
  backend = "s3"
  config = {
    bucket = "terraform-state-remote-store"
    key    = "dev/vpc/terraform.tfstate"
    region = "ap-south-1"
  }
}

# Configure Datasource to use IAM instance profile & S3 Bucket details from Remote S3 Backend

data "terraform_remote_state" "iam-s3" {
  backend = "s3"
  config = {
    bucket = "terraform-state-remote-store"
    key    = "dev/ec2/terraform.tfstate"
    region = "ap-south-1"
  }
}

# Get latest Amazon Linux 2 AMI ID 
# Ref: https://aws.amazon.com/blogs/compute/query-for-the-latest-amazon-linux-ami-ids-using-aws-systems-manager-parameter-store/
# Run: aws ssm get-parameters-by-path --path "/aws/service/ami-amazon-linux-latest" to find the URL below in values

data "aws_ami" "amazon-linux" {
  most_recent = true
  owners = [ "amazon" ]
  filter {
    name = "name"
    values = [ "amzn2-ami-kernel-5.10*x86_64-gp2" ]
  }

  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }
}