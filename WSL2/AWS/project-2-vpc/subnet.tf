
# Create Subnets

resource "aws_subnet" "public-1a" {
    vpc_id = aws_vpc.myvpc.id
    availability_zone = var.subnet.public-1["zone"]
    cidr_block =  var.subnet.public-1["cidr"]
    tags = {
      Name = "Public-1A"
    }
}

resource "aws_subnet" "public-1b" {
    vpc_id = aws_vpc.myvpc.id
    availability_zone = var.subnet.public-2["zone"]
    cidr_block = var.subnet.public-2["cidr"]
    tags = {
      Name = "Public-1B"
    }
}

resource "aws_subnet" "private-1a" {
    vpc_id = aws_vpc.myvpc.id
    availability_zone = var.subnet.private-1["zone"]
    cidr_block = var.subnet.private-1["cidr"]
    tags = {
      Name = "Private-1A"
    }
}

resource "aws_subnet" "private-1b" {
    vpc_id = aws_vpc.myvpc.id
    availability_zone = var.subnet.private-2["zone"]
    cidr_block = var.subnet.private-2["cidr"]
    tags = {
      Name = "Private-1B"
    }
}

