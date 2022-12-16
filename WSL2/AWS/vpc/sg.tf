# Update Default Security Group of MyVPC

resource "aws_default_security_group" "myvpc-default-sg" {
  
  vpc_id = aws_vpc.myvpc.id

  ingress {
    protocol  = "tcp"
    # self      = true
    from_port = 22
    to_port   = 22
    cidr_blocks = [ "115.99.14.220/32" ]
    description = "Opening SSH Port"
  }

  ingress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
    description = "Opening HTTP port"
  }

  ingress {
    protocol = "-1"
    self = true
    from_port = 0
    to_port = 0
    description = "Allow all connection on all port from same security group"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "elb-sg" {
  name = "ELB-Security-Group"
  description = "Allows HTTP & HTTPS"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "Opening HTTP Port"
  }

  ingress {
    protocol = "tcp"
    from_port = 443
    to_port = 443
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "Opening HTTPS Port"
  }

   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

    tags = {
      "Name" = "ELB SG"
      "CreateBy" = "Terraform"
    }
}

resource "aws_security_group" "app-sg" {
  name = "App-Security-Group"
  description = "Allows HTTP & HTTPS"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    security_groups = [ aws_security_group.elb-sg.id ]
    description = "Allow HTTP from ELB SG"
  }

  ingress {
    protocol = "tcp"
    from_port = 443
    to_port = 443
    security_groups = [ aws_security_group.elb-sg.id ]
    description = "Allow HTTPS from ELB SG"
  }

  ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    security_groups = [ aws_default_security_group.myvpc-default-sg.id ]
    description = "Allow SSH from Default SG"
  }

  ingress {
    protocol = "-1"
    self = true
    from_port = 0
    to_port = 0
    description = "Allow all connection on all port from same security group"
  }

   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

    tags = {
      "Name" = "App SG"
      "CreateBy" = "Terraform"
    }
}

