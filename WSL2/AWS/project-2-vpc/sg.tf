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

