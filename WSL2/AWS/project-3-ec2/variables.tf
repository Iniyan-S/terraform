# Declare Region Value

variable "reg" {
    default = "ap-south-1"
    type = string 
    description = "VPC Region"
}

# Declare AMI value

variable "use-ami" {
  type = string
  default = "ami-06489866022e12a14"
  description = "Amazon Linux Image ID"
}

# Declare Instance Type

variable "instance-type" {
  type = string
  default = "t2.micro"
  description = "Instance class and type"
}

# Declare Key Name

variable "key-name" {
  type = string
  default = "in-user"
  description = "Key Pair name to use"
}