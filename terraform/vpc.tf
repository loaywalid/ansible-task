resource "aws_vpc" "my_vpc" {
  cidr_block         = "10.0.0.0/16"
}

resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-west-1c"
}

resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.my_vpc.id
  map_public_ip_on_launch = true
  cidr_block = "10.0.2.0/24"
   availability_zone = "us-west-1b"
}

resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-1c"
}

resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-west-1b"
}


resource "aws_internet_gateway" "my_gateway" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_eip" "nat_ip" {

}

resource "aws_nat_gateway" "my_nat" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.public1.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route" "public_route" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.my_gateway.id
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route" "private_route" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.my_nat.id
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "sec_group" {
  name        = "pub-sec-group"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}