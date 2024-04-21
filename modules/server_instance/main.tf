variable "server_names" {
  description = "A map of server names to subnet and security group"
  type        = map(map(string))
}

variable "ami" {
  description = "The ID of the AMI to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
}

resource "aws_instance" "server" {
  for_each = var.server_names

  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = each.value["subnet"]
  vpc_security_group_ids = [each.value["secure-group"]]

  tags = {
    Name = each.key
  }
}