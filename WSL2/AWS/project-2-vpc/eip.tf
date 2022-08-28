# Create Elastic IP
resource "aws_eip" "myvpc-eip" {
  vpc = true
}