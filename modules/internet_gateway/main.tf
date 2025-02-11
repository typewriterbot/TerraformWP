resource "aws_internet_gateway" "wordpress_igw" {
  vpc_id = var.vpc_id
  tags = {
    Name = "WordPress Internet Gateway"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wordpress_igw.id
  }
  tags = {
    Name = "WordPress Public Route Table"
  }
}

resource "aws_route_table_association" "public_rta" {
  subnet_id      = var.public_subnet_id
  route_table_id = aws_route_table.public_rt.id
}