provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "Myvpc" {
  cidr_block = "10.100.0.0/16"
}

resource "aws_internet_gateway" "Myvpc-gateway" {
  vpc_id = aws_vpc.Myvpc.id
}

output "Myvpc-gateway" {
  value = aws_internet_gateway.Myvpc-gateway.id
}


resource "aws_subnet" "Myvpc-public" {
  vpc_id     = aws_vpc.Myvpc.id
  cidr_block = "10.100.0.0/24"

  tags = {
    Name = "Myvpc-public"
  }
}

resource "aws_subnet" "Myvpc-private" {
  vpc_id     = aws_vpc.Myvpc.id
  cidr_block = "10.100.1.0/24"

  tags = {
    Name = "Myvpc-private"
  }
}

resource "aws_route_table" "Myvpc-public" {
  vpc_id = aws_vpc.Myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Myvpc-gateway.id
  }

  tags = {
    Name = "Myvpc-public"
  }
}

resource "aws_route_table_association" "Myvpc-public" {
  subnet_id      = aws_subnet.Myvpc-public.id
  route_table_id = aws_route_table.Myvpc-public.id
}

resource "aws_route_table" "Myvpc-private" {
  vpc_id = aws_vpc.Myvpc.id

  tags = {
    Name = "Myvpc-private"
  }
}

resource "aws_route_table_association" "Myvpc-private" {
  subnet_id      = aws_subnet.Myvpc-private.id
  route_table_id = aws_route_table.Myvpc-private.id
}

output "public_route_table_id" {
  value = aws_route_table.Myvpc-public.id
}

output "private_route_table_id" {
  value = aws_route_table.Myvpc-private.id
}
