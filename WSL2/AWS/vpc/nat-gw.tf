# Create NAT Gateway and Associate Elastic IP

resource "aws_nat_gateway" "myvpc-nat-gw" {
  allocation_id = aws_eip.myvpc-eip.id
  subnet_id = aws_subnet.public-1a.id

  tags = {
    "Name" = "MyVPC NAT Gateway"
  }

  depends_on = [aws_internet_gateway.myvpc-igw]
}