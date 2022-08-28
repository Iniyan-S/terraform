output "vpc-id" {
  value = aws_vpc.myvpc.id
}

output "public-subnet-1-id" {
  value = aws_subnet.public-1a.id 
}

output "public-subnet-2-id" {
  value = aws_subnet.public-1b.id
}

output "private-subnet-1-id" {
  value = aws_subnet.private-1a.id
}

output "private-subnet-2-id" {
  value = aws_subnet.private-1b.id
}

output "default-sg-id" {
  value = aws_default_security_group.myvpc-default-sg.id
}