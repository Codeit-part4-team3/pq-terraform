provider "aws" {
  region  = "us-west-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

locals {
  server_names = {
    "user-server" = { "secure-group" = aws_security_group.pq-group.id, "subnet" = aws_subnet.subnet["user-subnet"].id }, 
    "chat-server" = { "secure-group" = aws_security_group.pq-group.id, "subnet" = aws_subnet.subnet["chat-subnet"].id }, 
    "socket-server" = { "secure-group" = aws_security_group.pq-group.id, "subnet" = aws_subnet.subnet["socket-subnet"].id }
  }
}

module "server_instance" {
  source        = "./modules/server_instance"
  server_names  = local.server_names
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
}