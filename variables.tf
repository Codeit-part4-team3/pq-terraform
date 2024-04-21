variable "subnets" {
  description = "A map of subnets"
  type        = map(object({
    cidr_block        = string
    availability_zone = string
    public_ip         = bool
  }))
  default = {
    "public-subnet" = {
      cidr_block        = "10.0.0.0/24"
      availability_zone = "us-west-2d"
      public_ip         = true
    },
    "user-subnet" = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-west-2a"
      public_ip         = false
    },
    "chat-subnet" = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-west-2a"
      public_ip         = false
    },
    "socket-subnet" = {
      cidr_block        = "10.0.3.0/24"
      availability_zone = "us-west-2a"
      public_ip         = false
    }
  }
}