# VPC ID
# Subnet Name - Not available in TF
# Availability Zone
# CIDR Block
# Tag - Optional 

# Create Subnets

resource "aws_subnet" "public-1a" {
    vpc_id = aws_vpc.myvpc.id
    availability_zone = "ap-south-1a"
    cidr_block =  "192.168.1.0/24"
    tags = {
      Name = "Public-1A"
    }
}

resource "aws_subnet" "public-1b" {
    vpc_id = aws_vpc.myvpc.id
    availability_zone = "ap-south-1b"
    cidr_block = "192.168.2.0/24"
    tags = {
      Name = "Public-1B"
    }
}

resource "aws_subnet" "private-1a" {
    vpc_id = aws_vpc.myvpc.id
    availability_zone = "ap-south-1a"
    cidr_block =  "192.168.3.0/24"
    tags = {
      Name = "Private-1A"
    }
}

resource "aws_subnet" "private-1b" {
    vpc_id = aws_vpc.myvpc.id
    availability_zone = "ap-south-1b"
    cidr_block = "192.168.4.0/24"
    tags = {
      Name = "Private-1B"
    }
}

