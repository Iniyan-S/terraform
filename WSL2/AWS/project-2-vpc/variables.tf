# Declare Region Value

variable "reg" {
    default = "ap-south-1"
    type = string 
    description = "VPC Region"
}


variable "vpc_cidr" {
    default = "192.168.0.0/16"
    type = string
    description = "Define VPC CIDR block"
}

# variable "subnet" {
#     type = object({
#         az = map(string)
#         cidr = list(string)
#     })

#     default = {
#         az = {
#             "zone-1" = "ap-south-1a"
#             "zone-2" = "ap-south-1b"
#         }

#         cidr = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24", "192.168.4.0/24"]
#     }

# }


variable "subnet" {
    type = object({
        public-1 = map(string)
        public-2 = map(string)
        private-1 = map(string)
        private-2 = map(string)
    })

    default = {
        public-1 = {
        "zone" = "ap-south-1a"
        "cidr" = "192.168.1.0/24"     
        }

        public-2 = {
        "zone" = "ap-south-1b"
        "cidr" = "192.168.3.0/24"
        }

        private-1 = {
        "zone" = "ap-south-1a"
        "cidr" = "192.168.2.0/24"
        }

        private-2 = {
        "zone" = "ap-south-1b"
        "cidr" = "192.168.4.0/24"
        }
    }
}

variable "route_outbound_cidr" {
    default = "0.0.0.0/0"
  
}