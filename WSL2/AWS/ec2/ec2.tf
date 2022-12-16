# Define EC2 Instance Configuration Values

# Name 
# AMI
# Instance Type
# Key Pair
# Network Settings:
#     - VPC id
#     - Subnet 
#     - Auto Assign IP
#     - SG 
# Storage Volume (root)

resource "aws_instance" "web" {
  ami = var.use-ami
  instance_type = var.instance-type
  key_name = var.key-name
  subnet_id = data.terraform_remote_state.myvpc.outputs.public-subnet-1-id
  security_groups = [data.terraform_remote_state.myvpc.outputs.default-sg-id]
  iam_instance_profile = aws_iam_instance_profile.instance-profile.name

  tags = {
    "Name" = "Web Host"
    "CreatedBy" = "Terraform"
  }
}