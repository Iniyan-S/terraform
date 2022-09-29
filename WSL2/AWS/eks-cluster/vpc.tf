# Create VPC

resource "aws_vpc" "my-eks-vpc" {
  cidr_block = "192.168.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "my-eks-vpc"
  }
}

# Create Public Subnets

resource "aws_subnet" "my-eks-sn-01" {
    vpc_id = aws_vpc.my-eks-vpc.id
    cidr_block = "192.168.1.0/24"
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true

    tags = {
      "kubernetes.io/cluster/my-eks-cluster" = "shared"
      }
}

resource "aws_subnet" "my-eks-sn-02" {
    vpc_id = aws_vpc.my-eks-vpc.id
    cidr_block = "192.168.2.0/24"
    availability_zone = "ap-south-1b"
    map_public_ip_on_launch = true

    tags = {
        "kubernetes.io/cluster/my-eks-cluster" = "shared"
    }
}

# Create IGW 

resource "aws_internet_gateway" "my-eks-vpc-igw" {
    vpc_id = aws_vpc.my-eks-vpc.id

    tags = {
        Name = "my-eks-vpc-igw"
    }
}

# Update Default Route table to have IGW for outbound

resource "aws_default_route_table" "my-eks-vpc-default-rt" {
    default_route_table_id = aws_vpc.my-eks-vpc.default_route_table_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my-eks-vpc-igw.id 
    }

    tags = {
        Name = "my-eks-vpc-default-rt"
    }
}

# Associate Public Subnets to Default Route Table

resource "aws_route_table_association" "my-eks-sn-01" {
    subnet_id = aws_subnet.my-eks-sn-01.id
    route_table_id = aws_default_route_table.my-eks-vpc-default-rt.id 
}

resource "aws_route_table_association" "my-eks-sn-02" {
    subnet_id = aws_subnet.my-eks-sn-02.id
    route_table_id = aws_default_route_table.my-eks-vpc-default-rt.id 
}


# Create Security Group for Worker Nodes SSH Access

resource "aws_security_group" "my-eks-ng-sg" {
  name = "allow-ssh"
  description = "Allow SSH Access to Worker Nodes"
  vpc_id = aws_vpc.my-eks-vpc.id

  ingress {
    description = "SSH Access"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "115.99.14.220/32" ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}