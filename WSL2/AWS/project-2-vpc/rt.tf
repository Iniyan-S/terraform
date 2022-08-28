# Update Default Route Table to use MyVPC IGW (The Route Table that was created by default with VPC creation process)

resource "aws_default_route_table" "myvpc-public-rt" {
  default_route_table_id = aws_vpc.myvpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myvpc-igw.id
  }

  tags = {
    "Name" = "MyVPC Public Subnets RT"
  }
}

# Create Custom Route Table with NAT Gateway to use with MyVPC 

resource "aws_route_table" "myvpc-private-rt" {
    vpc_id = aws_vpc.myvpc.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.myvpc-nat-gw.id
    }

    tags = {
        "Name" = "MyVPC Private Subnets RT"
    }
  
}

# Associate Public Subnets with Public Route Table

resource "aws_route_table_association" "myvpc-public-rt-associate-public-1a" {
  subnet_id = aws_subnet.public-1a.id
  route_table_id = aws_default_route_table.myvpc-public-rt.id
}

resource "aws_route_table_association" "myvpc-public-rt-associate-public-1b" {
  subnet_id = aws_subnet.public-1b.id
  route_table_id = aws_default_route_table.myvpc-public-rt.id
}

# Associate Private Subnets with Private Route Table

resource "aws_route_table_association" "myvpc-private-rt-associate-private-1a" {
    subnet_id = aws_subnet.private-1a.id
    route_table_id = aws_route_table.myvpc-private-rt.id
}

resource "aws_route_table_association" "myvpc-private-rt-associate-private-1b" {
    subnet_id = aws_subnet.private-1b.id
    route_table_id = aws_route_table.myvpc-private-rt.id
}