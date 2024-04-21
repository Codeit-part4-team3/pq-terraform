resource "aws_vpc" "vpc-pq" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc-pq"
  }
}

resource "aws_subnet" "subnet" {
  for_each = var.subnets

  vpc_id                  = aws_vpc.vpc-pq.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.public_ip

  tags = {
    Name = each.key
  }
}

resource "aws_security_group" "pq-group" {
  name = "pq-group"
  description = "Allow all inbound traffic"
  vpc_id = "${aws_vpc.vpc-pq.id}"

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}