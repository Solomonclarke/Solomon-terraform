resource "aws_vpc" "solomon-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "solomon-vpc"
  }
}

resource "aws_subnet" "public-subnet-1" {
  vpc_id     = aws_vpc.solomon-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id     = aws_vpc.solomon-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "public-subnet-2"
  }
}

resource "aws_subnet" "private-subnet-1" {
  vpc_id     = aws_vpc.solomon-vpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id     = aws_vpc.solomon-vpc.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "private-subnet-2"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.solomon-vpc.id
  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.solomon-vpc.id
  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "public-route-1-association" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "public-route-2-association" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "private-route-3-association" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_route_table_association" "private-route-4-association" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_internet_gateway" "solomon-IGW" {
  vpc_id = aws_vpc.solomon-vpc.id

  tags = {
    Name = "solomon-IGW"
  }
}

resource "aws_route" "public-igw-route" {
  route_table_id         = aws_route_table.public-route-table.id
  gateway_id             = aws_internet_gateway.solomon-IGW.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_eip" "nat" {
  vpc = true
  tags = {
    Name = "eip"
  }

}

resource "aws_nat_gateway" "solomon_ngw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-subnet-1.id

  tags = {
    Name = "solomon_ngw"
  }
}

resource "aws_route" "private-ngw-route" {
  route_table_id         = aws_route_table.private-route-table.id
  gateway_id             = aws_nat_gateway.solomon_ngw.id
  destination_cidr_block = "0.0.0.0/0"

}
