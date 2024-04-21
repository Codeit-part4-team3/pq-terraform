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

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc-pq.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc-pq.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "igw-rt"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.subnet["public-subnet"].id
}

resource "aws_route_table" "chat" {
  vpc_id = aws_vpc.vpc-pq.id

  route {
    cidr_block = "10.0.0.0/24"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "chat-subnet-rt"
  }
}

resource "aws_route_table" "user" {
  vpc_id = aws_vpc.vpc-pq.id

  route {
    cidr_block = "10.0.0.0/24"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "user-subnet-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.subnet["public-subnet"].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "user" {
  subnet_id      = aws_subnet.subnet["user-subnet"].id
  route_table_id = aws_route_table.user.id
}

resource "aws_route_table_association" "chat" {
  subnet_id      = aws_subnet.subnet["chat-subnet"].id
  route_table_id = aws_route_table.chat.id
}
