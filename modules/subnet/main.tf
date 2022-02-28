resource "aws_subnet" "my_subnet1" {
  cidr_block        = var.subnet_cidr_blocks
  vpc_id            = var.vpc_id
  availability_zone = var.avail_zone
  tags = {
    Name : "${var.env_prefix}-subnet-1"
  }
}

resource "aws_route_table" "my-route-table" {
  vpc_id = var.vpc_id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-gateway.id
  } 

  tags = {
    Name : "${var.env_prefix}-route-table"
  }
}

resource "aws_internet_gateway" "my-gateway" {
  vpc_id = var.vpc_id

  tags = {
    Name : "${var.env_prefix}-internet-gateway"
  }

}